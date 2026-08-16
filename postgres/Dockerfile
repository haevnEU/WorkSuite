FROM postgres:16-alpine

# Init-Skript in den automatischen Ausführungs-Ordner kopieren
COPY init_scripts/01-init.sql /docker-entrypoint-initdb.d/01-init.sql

# Sicherstellen, dass das Skript lesbar ist
RUN chmod 644 /docker-entrypoint-initdb.d/01-init.sql