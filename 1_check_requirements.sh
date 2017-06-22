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

check_file_exists() {
  if [ ! -f $1 ]; then
    echo "File not found: $1"
    exit 1
  fi
}

check_file_exists "$MEDIA/linuxamd64_12102_database_1of2.zip"
check_file_exists "$MEDIA/linuxamd64_12102_database_2of2.zip"
check_file_exists "$MEDIA/12.1.0.2.0_Database_Template_for_EM13_2_0_0_0_Linux_x64.zip"
check_file_exists "$MEDIA/em13200p1_linux64.bin"
check_file_exists "$MEDIA/em13200p1_linux64-2.zip"
check_file_exists "$MEDIA/em13200p1_linux64-3.zip"
check_file_exists "$MEDIA/em13200p1_linux64-4.zip"
check_file_exists "$MEDIA/em13200p1_linux64-5.zip"
check_file_exists "$MEDIA/em13200p1_linux64-6.zip"
check_file_exists "$MEDIA/em13200p1_linux64-7.zip"

get_existing_dir() {
  if [ -d $1 ]; then
    echo "$1"
  else
    echo $(get_existing_dir $(dirname "$1"))
  fi
}

check_free_space() {
  dir=$(get_existing_dir $1)
  if [ "$(df --block-size=1G "$dir" | awk 'NR==2 {print $2}')" -lt "$2" ]; then
    echo "Not enough free space in $1"
    exit 1
  fi
}

check_free_space "$STAGING"                13
check_free_space "$ORACLE_BASE"            30
check_free_space "$ORACLE_MIDDLEWARE_HOME" 28

check_swap_size() {
  if [ "$(free -m | grep Swap | awk '{print $2}')" -lt "$1" ]; then
    echo "Not enough swap"
    exit 1
  fi
}

check_swap_size 512
