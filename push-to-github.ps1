# Pushes the ManHrish folder to https://github.com/amolhekade/ManHrish
Set-Location -Path $PSScriptRoot
$ErrorActionPreference = 'Continue'
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Host "Git is not installed. Get it from https://git-scm.com/download/win" -ForegroundColor Red; Read-Host "Press Enter to close"; exit 1 }

# Trust this folder (the .git folder was created by an Administrator window)
$safe = ($PSScriptRoot -replace "\\","/")
if (-not (git config --global --get-all safe.directory | Where-Object { $_ -eq $safe })) { git config --global --add safe.directory $safe }

if (-not ((Test-Path README.md) -and (Select-String -Path README.md -SimpleMatch "# ManHrish" -Quiet))) { Add-Content -Path README.md -Value "# ManHrish" -Encoding utf8 }
if (-not (Test-Path .git)) { git init }
# Commit identity for this repository (only if not already set)
if (-not (git config user.email)) { git config user.email "aphekade@gmail.com" }
if (-not (git config user.name))  { git config user.name "Amol Hekade" }
git add README.md
if (-not (git rev-parse --verify HEAD 2>$null)) { git commit -m "first commit" }
git add .
git commit -m "Add ManHrish Technologies website"
git branch -M main
if (-not (git remote | Select-String -SimpleMatch origin)) { git remote add origin https://github.com/amolhekade/ManHrish.git }
git push -u origin main

Write-Host ""
if ($LASTEXITCODE -eq 0) { Write-Host "Done - https://github.com/amolhekade/ManHrish" -ForegroundColor Green } else { Write-Host "Push failed - see the message above." -ForegroundColor Red }
Read-Host "Press Enter to close"
