#!/usr/bin/env bash

set -ex

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install elasticsearch kibana

sudo systemctl daemon-reload

es_config=$(mktemp)
cat > $es_config << EOF
node.name: logging.vaticle.com
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
discovery.type: single-node
http.port: 2053
xpack.security.enabled: true
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.key: /etc/elasticsearch/key.pem
xpack.security.http.ssl.certificate: /etc/elasticsearch/cert.pem
EOF


kibana_config=$(mktemp)
cat > $kibana_config << EOF
server.port: 443
server.host: "0.0.0.0"
server.name: "logging.vaticle.com"
elasticsearch.hosts: ["https://logging.vaticle.com:2053"]
server.ssl.enabled: true
server.ssl.certificate: /etc/elasticsearch/cert.pem
server.ssl.key: /etc/elasticsearch/key.pem
elasticsearch.username: "kibana_system"
server.publicBaseUrl: "https://logging.vaticle.com"
EOF

sudo mv $es_config /etc/elasticsearch/elasticsearch.yml
sudo chown root:elasticsearch /etc/elasticsearch/elasticsearch.yml
sudo chmod u+rw,g+rw /etc/elasticsearch/elasticsearch.yml

sudo mv $kibana_config /etc/kibana/kibana.yml
sudo chown root:kibana /etc/kibana/kibana.yml
sudo chmod u+rw,g+rw /etc/kibana/kibana.yml

sudo setcap cap_net_bind_service=+epi /usr/share/kibana/bin/kibana
sudo setcap cap_net_bind_service=+epi /usr/share/kibana/bin/kibana-plugin
sudo setcap cap_net_bind_service=+epi /usr/share/kibana/bin/kibana-keystore
sudo setcap cap_net_bind_service=+epi /usr/share/kibana/node/bin/node
