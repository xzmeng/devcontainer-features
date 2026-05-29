#!/bin/sh
set -e

CONFIG_REPO="${CONFIG_REPO:-https://github.com/xzmeng/config}"
CONFIG_REPO_BRANCH="${CONFIG_REPO_BRANCH:-main}"
CONFIG_REPO_DIR="${CONFIG_REPO_DIR:-~/config}"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"

if [ -z "$CONFIG_REPO" ]; then
    echo "ERROR: CONFIG_REPO is required. Please set it in devcontainer-feature.json options."
    exit 1
fi

echo "[config-bootstrap] Cloning config repo: $CONFIG_REPO (branch: $CONFIG_REPO_BRANCH)"

if [ -d "$CONFIG_REPO_DIR" ]; then
    rm -rf "$CONFIG_REPO_DIR"
fi

if [ -n "$GITHUB_TOKEN" ]; then
    # Inject token into the URL for private repos
    REPO_URL=$(echo "$CONFIG_REPO" | sed "s|https://|https://${GITHUB_TOKEN}@|")
else
    REPO_URL="$CONFIG_REPO"
fi

git clone --depth 1 --branch "$CONFIG_REPO_BRANCH" "$REPO_URL" "$CONFIG_REPO_DIR"

INSTALL_SCRIPT="$CONFIG_REPO_DIR/install.sh"
if [ -x "$INSTALL_SCRIPT" ] || [ -f "$INSTALL_SCRIPT" ]; then
    echo "[config-bootstrap] Running install.sh from config repo..."
    chmod +x "$INSTALL_SCRIPT"
    ( cd "$CONFIG_REPO_DIR" && ./install.sh )
else
    echo "[config-bootstrap] No install.sh found in config repo root. Nothing to execute."
fi

echo "[config-bootstrap] Done."
