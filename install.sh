#!/bin/bash

# =================================================================================
#  Finales, robustes Installationsskript für ELK Stack (v3) auf Ubuntu 24.04
#  Automatisiert alle während des Debuggings gefundenen Konfigurationsschritte.
# =================================================================================

# Stoppt das Skript sofort, wenn ein Befehl fehlschlägt
set -e

# --- BENUTZEREINGABEN ---
read -p "Bitte geben Sie Ihren Domain-Namen für Kibana ein (z.B. elk.example.com): " DOMAIN
read -p "Bitte geben Sie Ihre E-Mail-Adresse für Let's Encrypt an: " EMAIL
echo "Ein zufälliges, sicheres Passwort für den 'elastic'-Benutzer wird generiert."
ELASTIC_PASSWORD=$(openssl rand -base64 16)

# --- SCHRITT 1: SYSTEM-VORAUSSETZUNGEN ---
echo "### Schritt 1: System aktualisieren und Abhängigkeiten installieren ###"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 nginx ufw openssl

# --- SCHRITT 2: ELASTIC-REPOSITORY HINZUFÜGEN ---
echo "### Schritt 2: Elastic APT-Repository hinzufügen ###"
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# --- SCHRITT 3: ELK-STACK INSTALLIEREN ---
echo "### Schritt 3: Elasticsearch, Logstash und Kibana installieren ###"
sudo apt-get update
sudo apt-get install -y elasticsearch logstash kibana

# --- SCHRITT 4: ELASTICSEARCH KONFIGURIEREN UND STARTEN ---
echo "### Schritt 4: Elasticsearch konfigurieren ###"
sudo tee /etc/elasticsearch/elasticsearch.yml <<EOF
cluster.name: elasticsearch
node.name: elk
network.host: localhost
http.port: 9200
discovery.type: single-node
xpack.security.enabled: true
xpack.security.enrollment.enabled: true
xpack.security.http.ssl:
  enabled: true
  keystore.path: certs/http.p12
xpack.security.transport.ssl:
  enabled: true
  verification_mode: certificate
  keystore.path: certs/transport.p12
  truststore.path: certs/transport.p12
EOF

echo "### Schritt 5: Elasticsearch starten und Passwort setzen ###"
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

echo "Warte 45 Sekunden, bis Elasticsearch vollständig hochgefahren ist..."
sleep 45

# Setze das Passwort für den 'elastic'-Benutzer
echo "y" | sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -p "${ELASTIC_PASSWORD}"

# --- SCHRITT 6: KIBANA UND LOGSTASH SICHER KONFIGURIEREN ---
echo "### Schritt 6: Kibana & Logstash Service-Tokens erstellen ###"
# Service-Token für Kibana erstellen und extrahieren
KIBANA_TOKEN=$(sudo /usr/share/elasticsearch/bin/elasticsearch-service-tokens create elastic/kibana kibana-token | grep "value = " | awk '{print $3}')
# Service-Token für Logstash erstellen
LOGSTASH_TOKEN=$(sudo /usr/share/elasticsearch/bin/elasticsearch-service-tokens create elastic/logstash logstash-token | grep "value = " | awk '{print $3}')

# Korrigiert die Dateiberechtigung für die Token-Datei
sudo chown elasticsearch:elasticsearch /etc/elasticsearch/service_tokens

# Kibana-Konfiguration mit Token erstellen
echo "--> Konfiguriere Kibana..."
sudo tee /etc/kibana/kibana.yml <<EOF
server.port: 5601
server.host: "localhost"
elasticsearch.hosts: ["http://localhost:9200"]
elasticsearch.serviceAccountToken: "${KIBANA_TOKEN}"
EOF
# Permanente Verschlüsselungsschlüssel für Kibana hinzufügen
sudo /usr/share/kibana/bin/kibana-encryption-keys generate --force | sudo tee -a /etc/kibana/kibana.yml

# Logstash-Konfiguration mit Token erstellen
echo "--> Konfiguriere Logstash..."
