#!/usr/bin/env bash

set -ex

sudo gcloud secrets versions access latest --secret certificate | base64 -d | sudo tee /etc/elasticsearch/cert.pem
sudo gcloud secrets versions access latest --secret key | base64 -d | sudo tee /etc/elasticsearch/key.pem

sudo chmod a+r /etc/elasticsearch/cert.pem
sudo chmod a+r /etc/elasticsearch/key.pem
sudo chmod a+x /etc/elasticsearch/


sudo systemctl start elasticsearch

ES_PASSWORDS_FILE="/etc/elasticsearch/es-passwords.txt"

if [ ! -f $ES_PASSWORDS_FILE ]; then
  sudo /usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto -u "https://logging.vaticle.com:2053" --batch | sudo tee $ES_PASSWORDS_FILE
  KIBANA_SYSTEM_PASSWORD=$(sudo awk '/PASSWORD kibana_system/ { print $4 }' $ES_PASSWORDS_FILE)
  echo "elasticsearch.password: \"$KIBANA_SYSTEM_PASSWORD\"" | sudo tee -a /etc/kibana/kibana.yml
fi

sudo systemctl start kibana
