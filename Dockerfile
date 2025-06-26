# ================================
# Build image
# ================================
FROM swift:6.0-noble AS build

# Установка обновлений и зависимостей
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get install -y libjemalloc-dev

# Каталог сборки
WORKDIR /build

# Кеш-слой для зависимостей
COPY ./Package.* ./
RUN swift package resolve \
    $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

# Копируем исходный код
COPY . .

# Сборка приложения
RUN swift build -c release

# ================================
# Run image
# ================================
FROM ubuntu:noble

# Установка минимально необходимых пакетов
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install -y \
      libjemalloc2 \
      ca-certificates \
      tzdata \
    && rm -r /var/lib/apt/lists/*

# Создание пользователя vapor
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

# Каталог приложения
WORKDIR /app

# Копируем исполняемый файл
COPY --from=build /build/.build/release/InnerFlowServer .

# Копируем Swift runtime библиотеки
COPY --from=build /usr/lib/swift/linux /usr/lib/swift/linux

# Указываем путь к runtime библиотекам
ENV LD_LIBRARY_PATH=/usr/lib/swift/linux

# Настройки для краш-репортера (опционально)
ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no

# Копируем entrypoint скрипт
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Используем пользователя vapor
USER vapor:vapor

# Публикуем порт
EXPOSE 8080

# Запуск приложения через entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
