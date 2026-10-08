#!/usr/bin/env bash
# ==============================================================================
# Script: scripts/update.sh
# Purpose: Hourly updater for veritechcorp/ZabbixScripts repository
# Host Path: /opt/zabbix/scripts/update.sh
# ==============================================================================

set -euo pipefail

REPO_DIR="/opt/zabbix"
LOG_DIR="/var/log/zabbix-scripts"
LOG_FILE="${LOG_DIR}/update.log"

mkdir -p "${LOG_DIR}"

log_msg() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "${LOG_FILE}"
}

if [[ ! -d "${REPO_DIR}/.git" ]]; then
  log_msg "ERROR: Git repository not found at ${REPO_DIR}"
  exit 1
fi

log_msg "Starting hourly update check..."
cd "${REPO_DIR}"

if git fetch --quiet --timeout=10 origin; then
  LOCAL_HASH=$(git rev-parse HEAD)
  REMOTE_HASH=$(git rev-parse @{u} 2>/dev/null || echo "$LOCAL_HASH")

  if [[ "$LOCAL_HASH" != "$REMOTE_HASH" ]]; then
    log_msg "New changes detected. Pulling changes (HEAD: ${LOCAL_HASH} -> ${REMOTE_HASH})..."
    git pull --quiet --ff-only origin main || git pull --quiet --ff-only
    chmod +x "${REPO_DIR}/scripts/"*.sh 2>/dev/null || true
    if [[ -d "${REPO_DIR}/externalscripts" ]]; then
      find "${REPO_DIR}/externalscripts" -type f -exec chmod +x {} + 2>/dev/null || true
    fi
    log_msg "Update successfully applied."
  else
    log_msg "Repository is already up to date."
  fi
else
  log_msg "WARNING: Failed to fetch updates from remote origin (network timeout or offline)."
  exit 1
fi

exit 0
