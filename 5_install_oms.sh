#!/bin/bash
set -eu -o pipefail

# Load environment variables
envfile=.env
if [ ! -f $envfile ]; then
  echo "File not found: $envfile"
  exit 1
fi
# shellcheck disable=SC2046
export $(grep -v ^# < $envfile | xargs)

script_dir="$(cd "$(dirname "$0")" && pwd)"

# Create directories
sudo mkdir -p \
  "$ORACLE_MIDDLEWARE_HOME" "$AGENT_BASE_DIR" "$ORACLE_INSTANCE_HOME"
sudo chown -R oracle:oinstall \
  "$ORACLE_MIDDLEWARE_HOME" "$AGENT_BASE_DIR" "$ORACLE_INSTANCE_HOME"
sudo chmod -R 775 \
  "$ORACLE_MIDDLEWARE_HOME" "$AGENT_BASE_DIR" "$ORACLE_INSTANCE_HOME"

# Create response file
if [ -z "${DATABASE_HOSTNAME:-}" ]; then
  export DATABASE_HOSTNAME
  DATABASE_HOSTNAME=$(hostname --fqdn)
fi
mo "$script_dir/new_install.rsp.template" |
  sudo -u oracle tee "$STAGING/new_install.rsp" >/dev/null

# Install Enterprise Manager Cloud Control
cd "$STAGING"
sudo -u oracle "$MEDIA/em13200p1_linux64.bin" -silent \
  -responseFile "$STAGING/new_install.rsp" -J-Djava.io.tmpdir="$STAGING"
