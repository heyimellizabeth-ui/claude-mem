#!/bin/bash
# SessionStart hook for Claude Code on the web.
# Installs Node dependencies and builds hooks/manifests so tests and type
# checks work in fresh remote containers. Synchronous, idempotent.
set -euo pipefail

# Only run in remote (Claude Code on the web) sessions.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

echo "[session-start] Installing Node dependencies (npm install)..."
npm install

# Tests run via `bun test`; ensure bun is available.
if ! command -v bun >/dev/null 2>&1; then
  echo "[session-start] Installing bun..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

echo "[session-start] Building hooks and manifests (npm run build)..."
npm run build

echo "[session-start] Done."
