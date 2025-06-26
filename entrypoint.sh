#!/bin/bash
set -e

# Применить миграции
/app/InnerFlowServer migrate --yes

# Запустить сервер
exec /app/InnerFlowServer serve --env production --hostname 0.0.0.0 --port 8080 