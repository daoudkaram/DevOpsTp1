#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo ">> Creating files (if missing) and starting stack..."
# Defensive: ensure required files exist (compose + config placed next to script)
test -f docker-compose.yml || { echo "docker-compose.yml missing"; exit 1; }
test -f librechat.yaml || { echo "librechat.yaml missing"; exit 1; }

# Start everything
docker compose up -d

echo ">> Waiting for Ollama health..."
# Wait until Ollama responds
for i in {1..60}; do
  if curl -sf http://127.0.0.1:11434/api/tags >/dev/null; then
    break
  fi
  sleep 2
done

echo ">> Pulling model: qwen2.5:3b (this can take a few minutes the first time)"
docker exec -i ollama ollama pull qwen2.5:3b

echo ">> Verifying Ollama models..."
docker exec -i ollama ollama list || true

echo ">> LibreChat will be available at: http://localhost:3000"
echo "   Login/register in the UI, then pick the 'Ollama' endpoint and select 'qwen2.5:3b'."
echo "   In Agents -> Tools, you can enable Context7 MCP."

