@echo off
setlocal

REM Install gum using winget and pwsh
winget install Microsoft.PowerShell charmbracelet.gum

REM Define variables
set EZGIT_DIR=%~dp0

REM Add the directory containing ezgit.ps1 and ezgit.bat to PATH
setx PATH "%PATH%;%EZGIT_DIR%"

echo Installation complete.
endlocal