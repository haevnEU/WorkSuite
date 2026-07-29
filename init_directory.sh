#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Initialisiere Ordnerstruktur und .env Dateien...${NC}\n"

directories=(
  "env/dev"
  "env/prod"
  "shared"
)

for dir in "${directories[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    echo -e "${GREEN}Ordner erstellt: ${dir}${NC}"
  fi
done

cat << 'EOF' > env/dev/backend.dev.env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=worksuite_password
SPRING_MONGODB_URI=mongodb://worksuite_user:worksuite_password@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=true
HIBERNATE_DDL_AUTO=update

APP_REDMINE_URL=http://redmine:3000
APP_REDMINE_APIKEY=
APP_GITLAB_URL=
APP_GITLAB_API_KEY=
JWT_SECRET=dev_jwt_secret_change_me_in_prod

GRADLE_USER_HOME=/app/.gradle
EOF
echo -e "${CYAN}Datei befüllt: env/dev/backend.dev.env${NC}"

cat << 'EOF' > env/dev/auth-backend.dev.env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=worksuite_password
SPRING_MONGODB_URI=mongodb://worksuite_user:worksuite_password@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=true
HIBERNATE_DDL_AUTO=update

JWT_SECRET=dev_jwt_secret_change_me_in_prod

GRADLE_USER_HOME=/app/.gradle
EOF
echo -e "${CYAN}Datei befüllt: env/dev/auth-backend.dev.env${NC}"

cat << 'EOF' > env/dev/frontend.dev.env
VITE_API_BASE_URL=http://localhost/api/v1
NODE_ENV=development
CHOKIDAR_USEPOLLING=true
EOF
echo -e "${CYAN}Datei befüllt: env/dev/frontend.dev.env${NC}"

cat << 'EOF' > env/dev/mongo.dev.env
MONGO_INITDB_DATABASE=worksuite
MONGO_INITDB_ROOT_USERNAME=worksuite_user
MONGO_INITDB_ROOT_PASSWORD=worksuite_password
EOF
echo -e "${CYAN}Datei befüllt: env/dev/mongo.dev.env${NC}"

cat << 'EOF' > env/dev/postgres.dev.env
POSTGRES_DB=worksuite
POSTGRES_USER=worksuite_user
POSTGRES_PASSWORD=worksuite_password
EOF
echo -e "${CYAN}Datei befüllt: env/dev/postgres.dev.env${NC}"

cat << 'EOF' > env/prod/backend.prod.env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=CHANGE_ME_PROD_PASSWORD
SPRING_MONGODB_URI=mongodb://worksuite_user:CHANGE_ME_PROD_PASSWORD@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=false
HIBERNATE_DDL_AUTO=validate

APP_REDMINE_URL=
APP_REDMINE_APIKEY=
APP_GITLAB_URL=
APP_GITLAB_API_KEY=
JWT_SECRET=CHANGE_ME_PROD_JWT_SECRET
EOF
echo -e "${YELLOW}Datei befüllt: env/prod/backend.prod.env${NC}"

cat << 'EOF' > env/prod/auth-backend.prod.env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=CHANGE_ME_PROD_PASSWORD
SPRING_MONGODB_URI=mongodb://worksuite_user:CHANGE_ME_PROD_PASSWORD@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=false
HIBERNATE_DDL_AUTO=validate

JWT_SECRET=CHANGE_ME_PROD_JWT_SECRET
EOF
echo -e "${YELLOW}Datei befüllt: env/prod/auth-backend.prod.env${NC}"

cat << 'EOF' > env/prod/frontend.prod.env
VITE_API_BASE_URL=/api/v1
EOF
echo -e "${YELLOW}Datei befüllt: env/prod/frontend.prod.env${NC}"

cat << 'EOF' > env/prod/mongo.prod.env
MONGO_INITDB_DATABASE=worksuite
MONGO_INITDB_ROOT_USERNAME=worksuite_user
MONGO_INITDB_ROOT_PASSWORD=CHANGE_ME_PROD_PASSWORD
EOF
echo -e "${YELLOW}Datei befüllt: env/prod/mongo.prod.env${NC}"

cat << 'EOF' > env/prod/postgres.prod.env
POSTGRES_DB=worksuite
POSTGRES_USER=worksuite_user
POSTGRES_PASSWORD=CHANGE_ME_PROD_PASSWORD
EOF
echo -e "${YELLOW}Datei befüllt: env/prod/postgres.prod.env${NC}"

echo -e "\n${GREEN}Initialisierung erfolgreich abgeschlossen!${NC}"