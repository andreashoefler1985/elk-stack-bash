# ELK Stack - Automatisches Installationsskript für Ubuntu 24.04

[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-orange?logo=ubuntu)](https://ubuntu.com/)
[![Elasticsearch](https://img.shields.io/badge/Elasticsearch-8.x-005571?logo=elasticsearch)](https://www.elastic.co/elasticsearch/)
[![Kibana](https://img.shields.io/badge/Kibana-8.x-005571?logo=kibana)](https://www.elastic.co/kibana/)
[![Logstash](https://img.shields.io/badge/Logstash-8.x-005571?logo=logstash)](https://www.elastic.co/logstash/)

Dieses Repository enthält ein Bash-Skript zur automatischen Installation und Konfiguration des **ELK-Stacks** (Elasticsearch, Logstash, Kibana) auf einem Ubuntu 24.04 Server.

Das Skript konfiguriert den Stack in einem **Single-Node-Setup**, sichert die Kommunikation zwischen den Diensten mit Service-Tokens und richtet einen sicheren Zugriff auf Kibana über **Nginx als Reverse-Proxy** mit einem **Let's Encrypt SSL-Zertifikat** ein.

## ✨ Features

- **🚀 Vollautomatisch**: Von der Systemaktualisierung bis zum fertigen SSL-Zertifikat
- **🔒 Sicher**: Konfiguriert die interne Kommunikation mit Service-Tokens statt Passwörtern
- **⚡ Modern**: Nutzt die aktuellen Best Practices für den ELK-Stack (Version 8.x)
- **💪 Robust**: Behebt proaktiv bekannte Konfigurationsprobleme (z.B. Dateiberechtigungen, Konfigurationskonflikte)
- **👤 Benutzerfreundlich**: Generiert automatisch ein sicheres Passwort für den elastic-Superuser und gibt es am Ende aus

## 📋 Voraussetzungen

Bevor du das Skript ausführst, stelle sicher, dass die folgenden Bedingungen erfüllt sind:

| Anforderung | Details |
|-------------|---------|
| **Server** | Ein frisch installierter Ubuntu 24.04 LTS Server |
| **Zugriff** | Ein Benutzerkonto mit sudo-Rechten |
| **Domain** | Ein vollständig registrierter Domain- oder Subdomain-Name |
| **DNS-Konfiguration** | Ein A-Record in deinen DNS-Einstellungen, der von deiner Domain auf die öffentliche IP-Adresse deines Servers zeigt |
| **Firewall** | Die Ports 80 und 443 müssen für eingehenden Verkehr geöffnet sein |

## 🚀 Installation

Die Installation ist in drei einfachen Schritten erledigt:

### 1. Skript klonen oder herunterladen

```bash
git clone https://github.com/andreashoefler1985/elk-stack-bash.git
cd elk-stack-bash
```

oder lade das Skript manuell herunter:

```bash
wget https://raw.githubusercontent.com/andreashoefler1985/elk-stack-bash/main/install.sh
```

### 2. Skript ausführbar machen

```bash
chmod +x install.sh
```

### 3. Skript ausführen

```bash
sudo ./install.sh
```

> ⚠️ **Wichtig**: Das Skript wird dich nach deinem Domain-Namen und deiner E-Mail-Adresse für das SSL-Zertifikat fragen. Am Ende der Installation wird das automatisch generierte Passwort für den elastic-Benutzer angezeigt. **Speichere dieses Passwort an einem sicheren Ort!**

## 🔧 Was das Skript im Detail tut

Das Installationsskript führt folgende Schritte automatisch aus:

1. **System-Setup**: Aktualisiert das System und installiert Basispakete wie nginx und ufw
2. **Elastic Repository**: Fügt das offizielle Elastic APT-Repository hinzu
3. **ELK-Installation**: Installiert Elasticsearch, Logstash und Kibana
4. **Elasticsearch-Konfiguration**: Konfiguriert Elasticsearch für einen Single-Node-Betrieb und aktiviert die Sicherheitsfeatures
5. **Dienst-Authentifizierung**: Startet Elasticsearch und erstellt automatisch sichere Service-Tokens für Kibana und Logstash
6. **Berechtigungen**: Korrigiert die Dateiberechtigungen für die erstellte Token-Datei
7. **Kibana-Konfiguration**: Schreibt die Kibana-Konfiguration, um den Service-Token zu verwenden und generiert permanente Verschlüsselungsschlüssel
8. **Logstash-Konfiguration**: Erstellt eine Beispielkonfiguration für Logstash, die ebenfalls einen sicheren Service-Token für die Kommunikation nutzt
9. **Nginx & SSL**: Konfiguriert Nginx als Reverse-Proxy für Kibana und sichert die Verbindung mit einem Let's Encrypt SSL-Zertifikat
10. **Firewall**: Aktiviert die Firewall und gibt die notwendigen Ports frei (SSH, Nginx Full)
11. **Abschluss**: Gibt die Zugangsdaten und die URL zur fertigen Kibana-Instanz aus

## 🎉 Nach der Installation

Nachdem das Skript erfolgreich durchgelaufen ist:

- **🌐 Kibana-Zugriff**: Deine Kibana-Instanz ist unter `https://deine-domain.com` erreichbar
- **👤 Login**: Melde dich mit dem Benutzernamen `elastic` und dem am Ende des Skripts angezeigten Passwort an
- **📊 Log-Ingestion**: Logstash lauscht auf Port 5044 auf Daten von Elastic Beats (z.B. Filebeat, Metricbeat)

## 🛠️ Fehlerbehebung (Troubleshooting)

Sollte etwas nicht wie erwartet funktionieren, sind dies die ersten Befehle zur Überprüfung der einzelnen Dienste:

### Service-Status prüfen

```bash
# Status von Elasticsearch prüfen
sudo systemctl status elasticsearch.service

# Status von Kibana prüfen
sudo systemctl status kibana.service

# Status von Logstash prüfen
sudo systemctl status logstash.service

# Status von Nginx prüfen
sudo systemctl status nginx.service
```

### Detaillierte Logs anzeigen

```bash
sudo journalctl -u elasticsearch.service -n 100 --no-pager
sudo journalctl -u kibana.service -n 100 --no-pager
```

## 📄 Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).

---

<div align="center">
  <sub>Built with ❤️ for the ELK Stack Community</sub>
</div>
