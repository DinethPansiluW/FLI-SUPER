@echo off
:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\elevate.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\elevate.vbs"
    cscript //nologo "%temp%\elevate.vbs"
    del "%temp%\elevate.vbs"
    exit /b
)

:: ANSI color escape codes (only skyblue)
set "GREEN=[1;32m"
set "GREENU=[4;32m"
set "RED=[31m"
set "ORANGE=[33m"
set "RESET=[0m"
set "PINK=[3;35m"
set "SKYBLUE=[96m"


:: Main script starts here
echo Stopping Print Spooler service...
net stop spooler

echo Starting Print Spooler service...
echo.
echo %GREEN%Wait Few Seconds..........%RESET%
echo.
net start spooler
echo.
echo Print Spooler Service restarted successfully.
echo.
pause
