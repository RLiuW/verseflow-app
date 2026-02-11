# VerseFlow - Gera ícones de launcher a partir de assets/icon/verseflow_icon.png
# Execute na raiz do projeto: .\scripts\update_launcher_icon.ps1

Set-Location $PSScriptRoot\..

Write-Host "Instalando dependências..." -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Gerando ícones Android e iOS..." -ForegroundColor Cyan
dart run flutter_launcher_icons
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Concluído. Reconstrua o app (flutter run) para ver o ícone no emulador." -ForegroundColor Green
