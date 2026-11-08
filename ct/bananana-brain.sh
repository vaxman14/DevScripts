#!/usr/bin/env bash
_CS_DEFAULT_URL="https://raw.githubusercontent.com/community-scripts/DevScripts/main"
_cs_boot="${COMMUNITY_SCRIPTS_CORE_DIR:-$(dirname "${BASH_SOURCE[0]}")/../../core}/core/build.func"
source "$_cs_boot" 2>/dev/null || source <(curl -fsSL "${COMMUNITY_SCRIPTS_CORE_URL:-https://raw.githubusercontent.com/community-scripts/core/main}/core/build.func")
# Copyright (c) 2021-2026 community-scripts ORG
# Author: Roman Vaxman (vaxman14)
# License: MIT | https://github.com/community-scripts/DevScripts/raw/main/LICENSE
# Source: https://bananana.dev

APP="bananana-brain"
var_tags="${var_tags:-monitoring;rmm}"
var_cpu="${var_cpu:-1}"
var_ram="${var_ram:-1024}"
var_disk="${var_disk:-6}"
var_os="${var_os:-debian}"
var_version="${var_version:-13}"
var_arm64="${var_arm64:-yes}"
var_unprivileged="${var_unprivileged:-1}"
# The brain ships only as a container image, so it runs under Docker inside the LXC
var_nesting="${var_nesting:-1}"
var_keyctl="${var_keyctl:-1}"

header_info "$APP"
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources

  if [[ ! -f /opt/bananana-brain/compose.yaml ]]; then
    msg_error "No bananana brain Installation Found!"
    exit
  fi

  msg_info "Updating bananana brain"
  cd /opt/bananana-brain || exit
  $STD docker compose pull
  $STD docker compose up -d
  $STD docker image prune -f
  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}bananana brain setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW}Put the setup token from https://bananana.dev/start in /opt/bananana-brain/.env, then open the address bananana.dev gives you, or on your network:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}https://${IP}:18771${CL}"
