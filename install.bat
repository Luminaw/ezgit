@echo off
setlocal

REM Install PowerShell Core and gum using winget
winget install Microsoft.PowerShell
winget install charmbracelet.gum

set EZGIT_DIR=%~dp0
set TARGET_DIR=%EZGIT_DIR%\bin

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

REM Create symbolic links for ezgit.ps1 and ezgit.cmd in the target directory
mklink "%TARGET_DIR%\ezgit.ps1" "%EZGIT_DIR%\ezgit.ps1"
mklink "%TARGET_DIR%\ezgit.cmd" "%EZGIT_DIR%\ezgit.cmd"

REM Add the target directory to PATH
setx PATH "%PATH%;%TARGET_DIR%"

echo Installation complete. Please restart your command prompt to apply the PATH changes.
endlocal