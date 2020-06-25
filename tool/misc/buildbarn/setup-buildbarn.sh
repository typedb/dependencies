#!/usr/bin/env bash

set -ex

sudo apt update
sudo apt install -qy docker.io docker-compose
sudo usermod -aG docker buildbarn

git clone https://github.com/graknlabs/bb-deployments.git /home/buildbarn/bb-deployments/
git -C /home/buildbarn/bb-deployments/ checkout grakn-custom-setup
cd /home/buildbarn/bb-deployments/docker-compose/
bash ./run.sh
