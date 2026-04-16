@echo off

echo =========================================
echo   Docker Publish via WSL2
echo =========================================
echo.

REM Input parameters
set REGISTRY=%1
set USER=%2
set IMAGE=%3
set VERSION=%4

set currentDir=%cd%

echo Forwarding to WSL script...
echo.

wsl bash -c "cd \"$(wslpath '%currentDir%')\" && ./publish-to-private-docker-hub.sh %REGISTRY% %USER% %IMAGE% %VERSION%"

pause