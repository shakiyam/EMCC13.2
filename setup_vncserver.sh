#!/bin/bash
set -eu -o pipefail

sudo yum -y install tigervnc-server
sudo -u oracle vncserver
