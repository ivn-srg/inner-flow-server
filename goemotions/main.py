from fastapi import FastAPI
from pydantic import BaseModel
from transformers import pipeline

app = FastAPI()
classifier = pipeline("text-classification", model="/app/ru-go-emotions")

class TextIn(BaseModel):
    text: str

@app.post("/predict")
def predict(data: TextIn):
    result = classifier(data.text)
    # result: list of dicts with 'label' and 'score'
    emotions = [r['label'] for r in result[0] if r['score'] > 0.1]  # threshold
    return {"emotions": emotions} 