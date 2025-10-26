#!/usr/bin/env sh
# Dump a JFR snapshot from a running service container.
# Usage: scripts/jfr-dump.sh <service-name> [recording-name] [output-dir]
# - service-name: docker-compose service name (e.g., petclinic)
# - recording-name: optional JFR recording name to dump (default: service-name)
# - output-dir: optional directory inside container to save snapshot (default: /jfr)

set -eu

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <service-name> [recording-name] [output-dir]" >&2
  exit 1
fi

SERVICE="$1"
REC_NAME="${2:-$SERVICE}"
OUT_DIR="${3:-/jfr}"

# Detect docker compose CLI
if docker compose version >/dev/null 2>&1; then
  COMPOSE="docker compose"
elif docker-compose version >/dev/null 2>&1; then
  COMPOSE="docker-compose"
else
  echo "Neither 'docker compose' nor 'docker-compose' is available in PATH" >&2
  exit 1
fi

# Resolve container ID of the service
CONTAINER_ID=$($COMPOSE ps -q "$SERVICE") || true
if [ -z "${CONTAINER_ID:-}" ]; then
  echo "Could not find running container for service: $SERVICE" >&2
  exit 1
fi

# Timestamped filename
TS=$(date +%Y%m%d-%H%M%S)
FILENAME="$OUT_DIR/${SERVICE}-${TS}.jfr"

# Exec inside the container: find Java PID and dump
# 1) Try to dump by recording name first
# 2) If that fails, try without name (default recording)
# The Java PID may not be 1 if entrypoint used a shell; discover it via jcmd list

set +e

docker exec -i "$CONTAINER_ID" sh -lc '
  set -eu
  mkdir -p '"$OUT_DIR"'
  if ! command -v jcmd >/dev/null 2>&1; then
    echo "jcmd not found in container. Ensure JDK image is used." >&2
    exit 1
  fi
  PID=$(jcmd | head -n1 | cut -d" " -f1)
  if [ -z "$PID" ]; then
    echo "No Java process detected via jcmd" >&2
    exit 1
  fi
  # Try dump by name
  if jcmd "$PID" JFR.dump name='"$REC_NAME"' filename='"$FILENAME"' >/dev/null 2>&1; then
    echo "JFR snapshot dumped to '"$FILENAME"' (by name: '"$REC_NAME"')."
    exit 0
  fi
  # Fallback: dump default/active recording (if any)
  if jcmd "$PID" JFR.dump filename='"$FILENAME"' >/dev/null 2>&1; then
    echo "JFR snapshot dumped to '"$FILENAME"' (default recording)."
    exit 0
  fi
  echo "Failed to dump JFR snapshot. Ensure a recording is active or start one with JFR.start." >&2
  exit 1
'

EXIT_CODE=$?
set -e
exit $EXIT_CODE
