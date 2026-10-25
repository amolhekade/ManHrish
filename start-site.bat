@echo off
REM ManHrish Technologies - local web server launcher
REM Serves this folder at http://localhost:8092
cd /d "%~dp0"
set PORT=8092
echo.
echo  ManHrish Technologies - starting local site on http://localhost:%PORT%
echo  Press Ctrl+C in this window to stop the server.
echo.

where python >nul 2>nul
if %errorlevel%==0 (
  start "" http://localhost:%PORT%
  python -m http.server %PORT% --bind 127.0.0.1
  goto :eof
)

where py >nul 2>nul
if %errorlevel%==0 (
  start "" http://localhost:%PORT%
  py -m http.server %PORT% --bind 127.0.0.1
  goto :eof
)

REM No Python found - use the built-in PowerShell server
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start-site.ps1" -Port %PORT%
