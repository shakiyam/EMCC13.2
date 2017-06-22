#!/bin/bash
set -eu -o pipefail

# Install required package
sudo yum -y install oracle-rdbms-server-12cR1-preinstall glibc-devel glibc-devel.i686

# Configure kernel parameter
cat <<EOT | sudo tee -a /etc/sysctl.conf >/dev/null
net.ipv4.ip_local_port_range = 11000 65000
EOT

# Create directories
sudo mkdir -p /u01/app/
sudo chown -R oracle:oinstall /u01/app/
sudo chmod -R 775 /u01/app/

# Set oracle password
echo oracle:oracle | sudo chpasswd

# Install Mo
curl -sSL https://raw.githubusercontent.com/tests-always-included/mo/master/mo |
  sudo tee /usr/local/bin/mo >/dev/null
sudo chmod +x /usr/local/bin/mo
