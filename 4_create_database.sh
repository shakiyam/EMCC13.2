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

# Unzip database template
sudo -u oracle unzip "$MEDIA/12.1.0.2.0_Database_Template_for_EM13_2_0_0_0_Linux_x64.zip" \
  -d /u01/app/oracle/product/12.1.0.2/dbhome_1/assistants/dbca/templates/

# Create listener using netca
sudo -u oracle /u01/app/oracle/product/12.1.0.2/dbhome_1/bin/netca -silent -responseFile \
  /u01/app/oracle/product/12.1.0.2/dbhome_1/assistants/netca/netca.rsp

# Create response file
mo "$script_dir/dbca.rsp.template" |
  sudo -u oracle tee "$STAGING/dbca.rsp" >/dev/null

# Create database
sudo -u oracle /u01/app/oracle/product/12.1.0.2/dbhome_1/bin/dbca -silent -createDatabase \
  -responseFile "$STAGING/dbca.rsp"

# Configure oratab
cat <<EOT | sudo tee -a /etc/oratab >/dev/null
$ORACLE_SID:$ORACLE_HOME:Y
EOT

# Set environment variables
cat <<EOT | sudo -u oracle tee /home/oracle/.bash_profile >/dev/null
export ORACLE_BASE=$ORACLE_BASE
export ORACLE_HOME=$ORACLE_HOME
export ORACLE_SID=$ORACLE_SID
export PATH=\$PATH:\$ORACLE_HOME/bin
EOT
