from fastapi import FastAPI
from pydantic import BaseModel
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)

app = FastAPI()
model_id = "/app/mistral-7b-instruct-v0.2"
logger.info("Загружаю токенизатор...")
tokenizer = AutoTokenizer.from_pretrained(model_id)
logger.info("Токенизатор загружен")
logger.info("Загружаю модель...")
model = AutoModelForCausalLM.from_pretrained(model_id, torch_dtype="auto", device_map="auto")
logger.info("Модель загружена")

if tokenizer.pad_token is None:
    logger.info("pad_token не найден, устанавливаю pad_token = eos_token")
    tokenizer.pad_token = tokenizer.eos_token
else:
    logger.info("pad_token уже установлен: %s", tokenizer.pad_token)

class Message(BaseModel):
    role: str
    content: str
class PromptIn(BaseModel):
    messages: list[Message]

@app.post("/generate")
def generate(data: PromptIn):
    logger.info("Получен запрос: %s", data)
    try:
        messages = [m.dict() for m in data.messages]
        logger.info("messages: %s", messages)
        prompt = tokenizer.apply_chat_template(messages, tokenize=False)
        logger.info("Prompt для генерации: %s", prompt)
        logger.info("Prompt: %s", prompt)
        logger.info("input_ids len: %d", len(tokenizer(prompt, return_tensors="pt")['input_ids'][0]))
        inputs = tokenizer(prompt, return_tensors="pt", padding=True)
        input_ids = inputs['input_ids'].to(model.device)
        attention_mask = inputs['attention_mask'].to(model.device)
        logger.info("input_ids shape: %s", input_ids.shape)
        logger.info("attention_mask shape: %s", attention_mask.shape)
        with torch.no_grad():
            generated_ids = model.generate(
                input_ids,
                attention_mask=attention_mask,
                max_new_tokens=64,
                do_sample=True,
                pad_token_id=tokenizer.pad_token_id
            )
        logger.info("generated_ids shape: %s", generated_ids.shape)
        decoded = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)
        logger.info("Сгенерированный текст: %s", decoded[0])
        return {"result": decoded[0]}
    except Exception as e:
        logger.exception("Ошибка при генерации текста")
        raise 