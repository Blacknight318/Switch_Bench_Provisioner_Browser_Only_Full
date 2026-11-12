@echo off
setlocal
where py >nul 2>nul
if errorlevel 1 (
  echo Python launcher was not found. Install Python 3 or run any local static web server in this folder.
  pause
  exit /b 1
)
echo Starting a static localhost server. It does not process profiles, keys, or serial data.
echo Open http://127.0.0.1:8788/Switch_Bench_Provisioner_Browser_Only.html
py -m http.server 8788 --bind 127.0.0.1
