#!/usr/bin/env bash
set -euo pipefail

CONFIG_REPO="${CONFIG_REPO:-https://github.com/xzmeng/config}"
CONFIG_REPO_BRANCH="${CONFIG_REPO_BRANCH:-main}"
CONFIG_REPO_DIR="${CONFIG_REPO_DIR:-${HOME}/config}"

echo "[config-bootstrap] Cloning config repo: ${CONFIG_REPO} (branch: ${CONFIG_REPO_BRANCH})"

if [[ -n "${DEBUG:-}" ]]; then
    set -x
fi

git clone --depth 1 --branch "${CONFIG_REPO_BRANCH}" "${CONFIG_REPO}" "${CONFIG_REPO_DIR}"

INSTALL_SCRIPT="${CONFIG_REPO_DIR}/install.sh"
if [[ -f ${INSTALL_SCRIPT} ]]; then
    echo "[config-bootstrap] Running install.sh from config repo..."
    chmod +x "${INSTALL_SCRIPT}"
    (cd "${CONFIG_REPO_DIR}" && ./install.sh)
else
    echo "[config-bootstrap] No install.sh found in config repo root. Nothing to execute."
fi

echo "[config-bootstrap] Done."
