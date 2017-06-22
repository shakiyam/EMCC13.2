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

sudo -u oracle "$ORACLE_MIDDLEWARE_HOME/bin/emctl" stop oms -all
sudo -u oracle "$AGENT_HOME/bin/emctl" stop agent
sudo -u oracle "$ORACLE_HOME/bin/dbshut" "$ORACLE_HOME"
