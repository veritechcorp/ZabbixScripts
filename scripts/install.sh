#!/usr/bin/env bash
# ==============================================================================
# Script: scripts/install.sh
# Purpose: Bootstrap installer for veritechcorp/ZabbixScripts environment
# Target Host Path: /opt/zabbix/scripts/install.sh
# Target OS: Debian Linux
# ==============================================================================

set -euo pipefail

# Configuration
REPO_URL="https://github.com/veritechcorp/ZabbixScripts.git"
REPO_BRANCH="main"
TARGET_DIR="/opt/zabbix"
SCRIPTS_DIR="${TARGET_DIR}/scripts"
DOCKER_DIR="${TARGET_DIR}/docker"
EXTERNALSCRIPTS_DIR="${TARGET_DIR}/externalscripts"
LOG_DIR="/var/log/zabbix-scripts"
INSTALL_LOG="${LOG_DIR}/install.log"

# Prepare logging
mkdir -p "${LOG_DIR}"
touch "${INSTALL_LOG}"

log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
  echo "$msg" | tee -a "${INSTALL_LOG}"
}

log_error() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*"
  echo "$msg" >&2
  echo "$msg" >> "${INSTALL_LOG}"
}

# 1. Root Privileges Check
check_privileges() {
  if [[ "${EUID}" -ne 0 ]]; then
    log_error "This script must be executed as root (or with sudo)."
    exit 1
  fi
}

# 2. Debian Package Prerequisites
install_prerequisites() {
  log "Verifying Debian system dependencies..."
  local missing_pkgs=()
  for pkg in git curl ca-certificates logrotate; do
    if ! dpkg -s "${pkg}" >/dev/null 2>&1; then
      missing_pkgs+=("${pkg}")
    fi
  done

  if [[ ${#missing_pkgs[@]} -gt 0 ]]; then
    log "Installing missing prerequisites: ${missing_pkgs[*]}..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get install -y -qq --no-install-recommends "${missing_pkgs[@]}"
    log "Prerequisites installed successfully."
  else
    log "All baseline Debian packages are installed."
  fi
}

# 3. Directory Layout Initialization
initialize_directories() {
  log "Initializing directory structure under ${TARGET_DIR}..."
  mkdir -p "${SCRIPTS_DIR}"
  mkdir -p "${DOCKER_DIR}"
  mkdir -p "${EXTERNALSCRIPTS_DIR}"
  mkdir -p "${LOG_DIR}"
}

# 4. Clone or Update GitHub Repository
sync_repository() {
  log "Syncing repository from ${REPO_URL} into ${TARGET_DIR}..."

  if [[ -d "${TARGET_DIR}/.git" ]]; then
    log "Existing git repository found at ${TARGET_DIR}. Updating..."
    cd "${TARGET_DIR}"
    git config --global --add safe.directory "${TARGET_DIR}" || true
    git fetch --quiet --depth=1 origin "${REPO_BRANCH}" || git fetch --quiet origin "${REPO_BRANCH}"
    git reset --hard "origin/${REPO_BRANCH}" || git pull --ff-only
  else
    log "Cloning repository..."
    local temp_clone
    temp_clone=$(mktemp -d)
    git clone --depth=1 --branch "${REPO_BRANCH}" "${REPO_URL}" "${temp_clone}"
    cp -a "${temp_clone}/." "${TARGET_DIR}/"
    rm -rf "${temp_clone}"
    git config --global --add safe.directory "${TARGET_DIR}" || true
  fi
  log "Repository files synchronized successfully."
}

# 5. Set Permissions
set_permissions() {
  log "Setting script permissions..."
  if compgen -G "${SCRIPTS_DIR}/*.sh" > /dev/null; then
    chmod +x "${SCRIPTS_DIR}"/*.sh
  fi
  if [[ -d "${EXTERNALSCRIPTS_DIR}" ]]; then
    find "${EXTERNALSCRIPTS_DIR}" -type f -exec chmod +x {} + 2>/dev/null || true
  fi
}

# 6. Setup Log Rotation
setup_logrotate() {
  log "Configuring logrotate for /var/log/zabbix-scripts..."
  cat <<'EOF' > /etc/logrotate.d/zabbix-scripts
/var/log/zabbix-scripts/*.log {
    weekly
    rotate 4
    size 10M
    compress
    missingok
    notifempty
    copytruncate
}
EOF
  chmod 0644 /etc/logrotate.d/zabbix-scripts
}

# 7. Setup Automated Hourly Pull
setup_hourly_updater() {
  log "Configuring automated hourly update service..."
  if command -v systemctl >/dev/null 2>&1 && systemctl is-system-running >/dev/null 2>&1 || [[ -d /run/systemd/system ]]; then
    cat <<EOF > /etc/systemd/system/zabbix-scripts-update.service
[Unit]
Description=Zabbix Scripts Hourly Git Update
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
User=root
ExecStart=${SCRIPTS_DIR}/update.sh
StandardOutput=null
StandardError=journal
EOF

    cat <<EOF > /etc/systemd/system/zabbix-scripts-update.timer
[Unit]
Description=Run Zabbix Scripts Git Update hourly

[Timer]
OnCalendar=hourly
RandomizedDelaySec=120
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl daemon-reload
    systemctl enable --now zabbix-scripts-update.timer
    log "Systemd timer zabbix-scripts-update.timer enabled and started."
  else
    cat <<EOF > /etc/cron.d/zabbix-scripts-update
0 * * * * root ${SCRIPTS_DIR}/update.sh >/dev/null 2>&1
EOF
    chmod 0644 /etc/cron.d/zabbix-scripts-update
    log "Cron fallback configured."
  fi
}

# 8. Hooks prepared for upcoming steps
setup_docker_environment() {
  log "Docker environment hook prepared."
}

setup_credentials() {
  log "Credentials setup hook prepared."
}

main() {
  log "Starting veritechcorp/ZabbixScripts Bootstrap Installer"
  check_privileges
  install_prerequisites
  initialize_directories
  sync_repository
  set_permissions
  setup_logrotate
  setup_hourly_updater
  setup_docker_environment
  setup_credentials
  log "Bootstrap complete! Zabbix environment initialized at ${TARGET_DIR}"
}

main "$@"
