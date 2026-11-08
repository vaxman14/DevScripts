#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: Roman Vaxman (vaxman14)
# License: MIT | https://github.com/community-scripts/DevScripts/raw/main/LICENSE
# Source: https://bananana.dev

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

setup_docker

msg_info "Setting up bananana brain"
mkdir -p /opt/bananana-brain/data
cat <<EOF2 >/opt/bananana-brain/.env
# Setup token from https://bananana.dev/start (starts with bst_). Only used on the first start.
# After setting it: cd /opt/bananana-brain && docker compose up -d --force-recreate
BANANANA_SETUP_TOKEN=
EOF2
chmod 600 /opt/bananana-brain/.env
cat <<'EOF2' >/opt/bananana-brain/compose.yaml
services:
  bananana:
    image: romanvaxman/bananana-brain:latest
    container_name: bananana-brain
    restart: unless-stopped
    ports:
      - "18771:18771"
    environment:
      BANANANA_SETUP_TOKEN: ${BANANANA_SETUP_TOKEN:-}
    volumes:
      - /opt/bananana-brain/data:/data
EOF2
cd /opt/bananana-brain
$STD docker compose pull
$STD docker compose up -d
msg_ok "Set up bananana brain"

motd_ssh
customize
cleanup_lxc
