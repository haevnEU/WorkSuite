[CmdletBinding()]
param (
    [switch]$Dev,
    [switch]$Prod,
    [switch]$NoCache,
    [switch]$SkipSubmodules
)

$ErrorActionPreference = "Stop"

# Konsolen-Encoding auf UTF-8 setzen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       Worksuite Build & Deploy Pipeline " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Auswertung der Umgebung
$isProd = $false

if (-not $Dev -and -not $Prod) {
    Write-Host "`nBitte waehle die Ziel-Umgebung aus:" -ForegroundColor Yellow
    Write-Host "  [1] Development (docker-compose.dev.yml)" -ForegroundColor White
    Write-Host "  [2] Production  (docker-compose.yml)" -ForegroundColor White
    Write-Host "  [Q] Abbrechen" -ForegroundColor Gray

    $selection = Read-Host "`nEingabe [1/2/Q]"

    switch ($selection.ToString().Trim()) {
        "1" { $isProd = $false }
        "2" { $isProd = $true }
        "q" { Write-Host "Build abgebrochen." -ForegroundColor Red; exit 0 }
        "Q" { Write-Host "Build abgebrochen." -ForegroundColor Red; exit 0 }
        default {
            Write-Host "Ungueltige Eingabe! Standardmaessig wird Development gewaehlt." -ForegroundColor Yellow
            $isProd = $false
        }
    }
} else {
    $isProd = $Prod.IsPresent
}

# 2. Umgebung festlegen
$composeFile = if ($isProd) { "docker-compose.yml" } else { "docker-compose.dev.yml" }
$envName     = if ($isProd) { "Production" } else { "Development" }

if (-not (Test-Path $composeFile)) {
    Write-Host "`n[FEHLER] Die Datei '$composeFile' wurde im aktuellen Ordner nicht gefunden!" -ForegroundColor Red
    exit 1
}

# 3. Submodule prüfen & aktualisieren
if (-not $SkipSubmodules) {
    Write-Host "`n[1/4] Prüfe und aktualisiere Git Submodule..." -ForegroundColor Yellow
    git submodule update --init --recursive
    Write-Host "Submodule sind auf dem neuesten Stand." -ForegroundColor Green
} else {
    Write-Host "`n[1/4] Überspringe Submodul-Update (--SkipSubmodules)." -ForegroundColor Gray
}

# 4. Alte Container stoppen
Write-Host "`n[2/4] Stoppe laufende Container ($composeFile)..." -ForegroundColor Yellow
& docker compose -f $composeFile down
if ($LASTEXITCODE -ne 0) {
    Write-Host "Hinweis: 'docker compose down' meldete einen Fehler oder es liefen keine Container." -ForegroundColor Gray
}

# 5. Docker Compose Build ausführen
Write-Host "`n[3/4] Starte Docker Compose Build für $envName..." -ForegroundColor Yellow

$dockerBuildArgs = @("compose", "-f", $composeFile, "build")
if ($NoCache) {
    $dockerBuildArgs += "--no-cache"
    Write-Host "Build läuft ohne Cache (--no-cache)..." -ForegroundColor Gray
}

& docker @dockerBuildArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[FEHLER] Build fehlgeschlagen! Bitte prüfe die Log-Ausgabe oben." -ForegroundColor Red
    exit 1
}

# 6. Neue Container starten (docker compose up -d)
Write-Host "`n[4/4] Starte Container neu ($envName)..." -ForegroundColor Yellow
& docker compose -f $composeFile up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n==========================================" -ForegroundColor Green
    Write-Host " Build & Deploy erfolgreich abgeschlossen! " -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green
} else {
    Write-Host "`n[FEHLER] Fehler beim Starten der Container via 'docker compose up'!" -ForegroundColor Red
    exit 1
}