#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Initializing folder structure and .env files...${NC}\n"

directories=(
  "env/dev"
  "env/prod"
  "shared"
)

for dir in "${directories[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    echo -e "${GREEN}Folder created: ${dir}${NC}"
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
APP_VCS_URL=http://192.168.2.137:81
JWT_SECRET=4b7f921c8d6e3a5b4f0e1d2c3b4a5f6e7d8c9b0a1f2e3d4c5b6a7f8e9d0c1b2a

GRADLE_USER_HOME=/app/.gradle
EOF
echo -e "${CYAN}File populated: env/dev/backend.dev.env${NC}"

cat << 'EOF' > env/dev/auth-backend.dev.env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=worksuite_password
SPRING_MONGODB_URI=mongodb://worksuite_user:worksuite_password@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=true
HIBERNATE_DDL_AUTO=update

JWT_SECRET=4b7f921c8d6e3a5b4f0e1d2c3b4a5f6e7d8c9b0a1f2e3d4c5b6a7f8e9d0c1b2a

GRADLE_USER_HOME=/app/.gradle
EOF
echo -e "${CYAN}File populated: env/dev/auth-backend.dev.env${NC}"

cat << 'EOF' > env/dev/frontend.dev.env
VITE_API_BASE_URL=http://localhost/api/v1
NODE_ENV=development
CHOKIDAR_USEPOLLING=true
EOF
echo -e "${CYAN}File populated: env/dev/frontend.dev.env${NC}"

cat << 'EOF' > env/dev/mongo.dev.env
MONGO_INITDB_DATABASE=worksuite
MONGO_INITDB_ROOT_USERNAME=worksuite_user
MONGO_INITDB_ROOT_PASSWORD=worksuite_password
EOF
echo -e "${CYAN}File populated: env/dev/mongo.dev.env${NC}"

cat << 'EOF' > env/dev/postgres.dev.env
POSTGRES_DB=worksuite
POSTGRES_USER=worksuite_user
POSTGRES_PASSWORD=worksuite_password
EOF
echo -e "${CYAN}File populated: env/dev/postgres.dev.env${NC}"

cat << 'EOF' > env/prod/backend.prod.env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=<POSTGRES_PASSWORD>
SPRING_MONGODB_URI=mongodb://worksuite_user:<MONGO_INITDB_ROOT_PASSWORD>@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=false
HIBERNATE_DDL_AUTO=validate

APP_REDMINE_URL=
APP_GITLAB_URL=
JWT_SECRET=<JWT_SECRET>
EOF
echo -e "${YELLOW}File populated: env/prod/backend.prod.env${NC}"

cat << 'EOF' > env/prod/auth-backend.prod.env
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=<POSTGRES_PASSWORD>
SPRING_MONGODB_URI=mongodb://worksuite_user:<MONGO_INITDB_ROOT_PASSWORD>@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=false
HIBERNATE_DDL_AUTO=validate

JWT_SECRET=<JWT_SECRET>
EOF
echo -e "${YELLOW}File populated: env/prod/auth-backend.prod.env${NC}"

cat << 'EOF' > env/prod/frontend.prod.env
VITE_API_BASE_URL=/api/v1
EOF
echo -e "${YELLOW}File populated: env/prod/frontend.prod.env${NC}"

cat << 'EOF' > env/prod/mongo.prod.env
MONGO_INITDB_DATABASE=worksuite
MONGO_INITDB_ROOT_USERNAME=worksuite_user
MONGO_INITDB_ROOT_PASSWORD=<MONGO_INITDB_ROOT_PASSWORD>
EOF
echo -e "${YELLOW}File populated: env/prod/mongo.prod.env${NC}"

cat << 'EOF' > env/prod/postgres.prod.env
POSTGRES_DB=worksuite
POSTGRES_USER=worksuite_user
POSTGRES_PASSWORD=<POSTGRES_PASSWORD>
EOF
echo -e "${YELLOW}File populated: env/prod/postgres.prod.env${NC}"

echo -e "\n${GREEN}Initialization completed successfully!${NC}"
echo -e "\n${YELLOW}The following variables in 'env/prod/' must be adapted:"
echo -e " - POSTGRES_PASSWORD"
echo -e " - MONGO_INITDB_ROOT_USERNAME"
echo -e " - MONGO_INITDB_ROOT_PASSWORD"
echo -e " - JWT_SECRET"
echo -e " - APP_REDMINE_URL / APP_GITLAB_URL${NC}"