$directories = @(
    "env/dev",
    "env/prod",
    "shared"
)

foreach ($dir in $directories) {
    if (-not (Test-Path -Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Ordner erstellt: $dir" -ForegroundColor Green
    }
}

$devContents = @{
    "backend.dev.env" = @"
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
"@

    "auth-backend.dev.env" = @"
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=worksuite_password
SPRING_MONGODB_URI=mongodb://worksuite_user:worksuite_password@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=true
HIBERNATE_DDL_AUTO=update

JWT_SECRET=dev_jwt_secret_change_me_in_prod

GRADLE_USER_HOME=/app/.gradle
"@

    "frontend.dev.env" = @"
VITE_API_BASE_URL=http://localhost/api/v1
NODE_ENV=development
CHOKIDAR_USEPOLLING=true
"@

    "mongo.dev.env" = @"
MONGO_INITDB_DATABASE=worksuite
MONGO_INITDB_ROOT_USERNAME=worksuite_user
MONGO_INITDB_ROOT_PASSWORD=worksuite_password
"@

    "postgres.dev.env" = @"
POSTGRES_DB=worksuite
POSTGRES_USER=worksuite_user
POSTGRES_PASSWORD=worksuite_password
"@
}

$prodContents = @{
    "backend.prod.env" = @"
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
"@

    "auth-backend.prod.env" = @"
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/worksuite
SPRING_DATASOURCE_USERNAME=worksuite_user
SPRING_DATASOURCE_PASSWORD=CHANGE_ME_PROD_PASSWORD
SPRING_MONGODB_URI=mongodb://worksuite_user:CHANGE_ME_PROD_PASSWORD@mongodb:27017/worksuite?authSource=admin
SHOW_SQL=false
HIBERNATE_DDL_AUTO=validate

JWT_SECRET=CHANGE_ME_PROD_JWT_SECRET
"@

    "frontend.prod.env" = @"
VITE_API_BASE_URL=/api/v1
"@

    "mongo.prod.env" = @"
MONGO_INITDB_DATABASE=worksuite
MONGO_INITDB_ROOT_USERNAME=worksuite_user
MONGO_INITDB_ROOT_PASSWORD=CHANGE_ME_PROD_PASSWORD
"@

    "postgres.prod.env" = @"
POSTGRES_DB=worksuite
POSTGRES_USER=worksuite_user
POSTGRES_PASSWORD=CHANGE_ME_PROD_PASSWORD
"@
}

foreach ($fileName in $devContents.Keys) {
    $filePath = Join-Path "env/dev" $fileName
    Set-Content -Path $filePath -Value $devContents[$fileName] -Encoding UTF8
    Write-Host "Datei befüllt: $filePath" -ForegroundColor Cyan
}

foreach ($fileName in $prodContents.Keys) {
    $filePath = Join-Path "env/prod" $fileName
    Set-Content -Path $filePath -Value $prodContents[$fileName] -Encoding UTF8
    Write-Host "Datei befüllt: $filePath" -ForegroundColor Yellow
}

Write-Host "`nInitialisierung erfolgreich abgeschlossen!" -ForegroundColor Green