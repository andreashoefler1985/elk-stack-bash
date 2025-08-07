##ELK Stack
Automatisches Installationsskript für Ubuntu 24.04
Dieses Repository enthält ein Bash-Skript zur automatischen Installation und Konfiguration des ELK-Stacks (Elasticsearch, Logstash, Kibana) auf einem Ubuntu 24.04 Server.

Das Skript konfiguriert den Stack in einem Single-Node-Setup, sichert die Kommunikation zwischen den Diensten mit Service-Tokens und richtet einen sicheren Zugriff auf Kibana über Nginx als Reverse-Proxy mit einem Let's Encrypt SSL-Zertifikat ein.

Features
Vollautomatisch: Von der Systemaktualisierung bis zum fertigen SSL-Zertifikat.

Sicher: Konfiguriert die interne Kommunikation mit Service-Tokens statt Passwörtern.

Modern: Nutzt die aktuellen Best Practices für den ELK-Stack (Version 8.x).

Robust: Behebt proaktiv bekannte Konfigurationsprobleme (z.B. Dateiberechtigungen, Konfigurationskonflikte).

Benutzerfreundlich: Generiert automatisch ein sicheres Passwort für den elastic-Superuser und gibt es am Ende aus.

Voraussetzungen
Bevor du das Skript ausführst, stelle sicher, dass die folgenden Bedingungen erfüllt sind:

Server: Ein frisch installierter Ubuntu 24.04 LTS Server.

Zugriff: Ein Benutzerkonto mit sudo-Rechten.

Domain: Ein vollständig registrierter Domain- oder Subdomain-Name.

DNS-Konfiguration: Ein A-Record in deinen DNS-Einstellungen, der von deiner Domain auf die öffentliche IP-Adresse deines Servers zeigt.

Firewall: Die Ports 80 und 443 müssen für eingehenden Verkehr geöffnet sein, damit die SSL-Zertifikatserstellung durch Let's Encrypt funktioniert.

Installation
Die Installation ist in drei einfachen Schritten erledigt:

Skript klonen oder herunterladen:

git clone https://github.com/DEIN_BENUTZERNAME/DEIN_REPO.git
cd DEIN_REPO

oder lade das Skript manuell herunter:

wget https://raw.githubusercontent.com/DEIN_BENUTZERNAME/DEIN_REPO/main/install_elk.sh

Skript ausführbar machen:

chmod +x install_elk.sh

Skript ausführen:

sudo ./install_elk.sh

Das Skript wird dich nach deinem Domain-Namen und deiner E-Mail-Adresse für das SSL-Zertifikat fragen. Am Ende der Installation wird das automatisch generierte Passwort für den elastic-Benutzer angezeigt. Speichere dieses Passwort an einem sicheren Ort!

Was das Skript im Detail tut
System-Setup: Aktualisiert das System und installiert Basispakete wie nginx und ufw.

Elastic Repository: Fügt das offizielle Elastic APT-Repository hinzu.

ELK-Installation: Installiert Elasticsearch, Logstash und Kibana.

Elasticsearch-Konfiguration: Konfiguriert Elasticsearch für einen Single-Node-Betrieb und aktiviert die Sicherheitsfeatures.

Dienst-Authentifizierung: Startet Elasticsearch und erstellt automatisch sichere Service-Tokens für Kibana und Logstash.

Berechtigungen: Korrigiert die Dateiberechtigungen für die erstellte Token-Datei.

Kibana-Konfiguration: Schreibt die Kibana-Konfiguration, um den Service-Token zu verwenden und generiert permanente Verschlüsselungsschlüssel.

Logstash-Konfiguration: Erstellt eine Beispielkonfiguration für Logstash, die ebenfalls einen sicheren Service-Token für die Kommunikation nutzt.

Nginx & SSL: Konfiguriert Nginx als Reverse-Proxy für Kibana und sichert die Verbindung mit einem Let's Encrypt SSL-Zertifikat.

Firewall: Aktiviert die Firewall und gibt die notwendigen Ports frei (SSH, Nginx Full).

Abschluss: Gibt die Zugangsdaten und die URL zur fertigen Kibana-Instanz aus.

Nach der Installation
Nachdem das Skript erfolgreich durchgelaufen ist:

Kibana-Zugriff: Deine Kibana-Instanz ist unter https://deine-domain.com erreichbar.

Login: Melde dich mit dem Benutzernamen elastic und dem am Ende des Skripts angezeigten Passwort an.

Log-Ingestion: Logstash lauscht auf Port 5044 auf Daten von Elastic Beats (z.B. Filebeat, Metricbeat).

Fehlerbehebung (Troubleshooting)
Sollte etwas nicht wie erwartet funktionieren, sind dies die ersten Befehle zur Überprüfung der einzelnen Dienste:

# Status von Elasticsearch prüfen
sudo systemctl status elasticsearch.service

# Status von Kibana prüfen
sudo systemctl status kibana.service

# Status von Logstash prüfen
sudo systemctl status logstash.service

# Status von Nginx prüfen
sudo systemctl status nginx.service

Detaillierte Log-Ausgaben erhältst du mit journalctl:

sudo journalctl -u elasticsearch.service -n 100 --no-pager
sudo journalctl -u kibana.service -n 100 --no-pager

Lizenz
Dieses Projekt steht unter der MIT-Lizenz.
