#!/usr/bin/env bash

# === Проверка аргументов ===
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <service_name> <restarts_count> <readiness_url>"
  echo "Example: $0  petclinic-aot 20 http://localhost:8091/actuator/health/readiness"
  exit 1
fi

SERVICE_NAME="$1"
RESTART_COUNT="$2"
READINESS_URL="$3"

# Максимальное время ожидания (в секундах) для readiness после рестарта
MAX_WAIT=60
SLEEP_BETWEEN_CHECKS=2

# === Основной цикл ===
for i in $(seq 1 "$RESTART_COUNT"); do
  echo "🔁 Restart #$i: restarting service '$SERVICE_NAME'..."

  # Перезапуск сервиса в docker compose
  docker compose restart "$SERVICE_NAME"
  if [ $? -ne 0 ]; then
    echo "❌ Ошибка при перезапуске сервиса '$SERVICE_NAME'"
    exit 1
  fi

  echo "⏳ Ожидание readiness по адресу: $READINESS_URL"

  # Ждём readiness
  SECONDS_WAITED=0
  until curl -fs "$READINESS_URL" | grep -q '"status":"UP"'; do
    sleep "$SLEEP_BETWEEN_CHECKS"
    SECONDS_WAITED=$((SECONDS_WAITED + SLEEP_BETWEEN_CHECKS))
    if [ "$SECONDS_WAITED" -ge "$MAX_WAIT" ]; then
      echo "❌ Таймаут ожидания readiness ($MAX_WAIT сек)!"
      exit 1
    fi
  done

  echo "✅ Сервис '$SERVICE_NAME' готов (readiness OK)"
  sleep "5"
  echo
done

echo "🎉 Все $RESTART_COUNT рестартов завершены успешно!"
