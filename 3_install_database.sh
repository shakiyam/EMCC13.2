#!/bin/bash
set -eu -o pipefail

# Load environment variables
envfile=.env
if [ ! -f $envfile ]; then
  echo "$envfile file not found"
  exit 1
fi
# shellcheck disable=SC2046
export $(grep -v ^# < $envfile | xargs)

script_dir="$(cd "$(dirname "$0")" && pwd)"

# unzip Oracle Database media
sudo -u oracle unzip "$MEDIA/linuxamd64_12102_database_1of2.zip" -d "$STAGING"
sudo -u oracle unzip "$MEDIA/linuxamd64_12102_database_2of2.zip" -d "$STAGING"

# Create response file
mo "$script_dir/db_install.rsp.template" |
  sudo -u oracle tee "$STAGING/db_install.rsp" >/dev/null

# Install Oracle Database
sudo -u oracle "$STAGING/database/runInstaller" -silent -showProgress \
  -ignorePrereq  -waitforcompletion -responseFile "$STAGING/db_install.rsp"
sudo /u01/app/oraInventory/orainstRoot.sh
sudo /u01/app/oracle/product/12.1.0.2/dbhome_1/root.sh
