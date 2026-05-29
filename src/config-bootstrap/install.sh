#!/usr/bin/env bash
set -euo pipefail

CONFIG_REPO="${CONFIG_REPO:-https://github.com/xzmeng/config}"
CONFIG_REPO_BRANCH="${CONFIG_REPO_BRANCH:-main}"
REMOTE_USER="${_REMOTE_USER:-root}"
CONFIG_REPO_DIR="${CONFIG_REPO_DIR:-/home/${_REMOTE_USER}/config}"


# If running as root and there is a non-root target user, switch to that user
# and re-execute this script so everything runs as the container's final user.
if [[ "$(id -u)" = "0" ]] && [[ "${REMOTE_USER}" != "root" ]]; then
    echo "[config-bootstrap] Switching to user: ${REMOTE_USER}"
    exec su - "${REMOTE_USER}" -c "bash '$0'"
fi

if [[ -n "${DEBUG:-}" ]]; then
    set -x
fi

echo "[config-bootstrap] Cloning config repo: ${CONFIG_REPO} (branch: ${CONFIG_REPO_BRANCH})"

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
