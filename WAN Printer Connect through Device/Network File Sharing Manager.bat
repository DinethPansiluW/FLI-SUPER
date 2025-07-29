@echo off
setlocal enabledelayedexpansion

:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    :: Create a temporary VBScript to relaunch this script with admin rights
    >"%temp%\getadmin.vbs" (
        echo Set UAC = CreateObject^("Shell.Application"^)
        echo UAC.ShellExecute "%~f0", "", "", "runas", 1
    )
    :: Run the VBScript silently and exit the current window
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit
)

:: Function to check if Network Discovery is enabled
for /f "tokens=3" %%A in ('netsh advfirewall firewall show rule name="Network Discovery" ^| findstr /i "Enabled"') do (
    set "netdisc=%%A"
)

:: Function to check if File and Printer Sharing is enabled
for /f "tokens=3" %%A in ('netsh advfirewall firewall show rule name="File and Printer Sharing (SMB-In)" ^| findstr /i "Enabled"') do (
    set "fileshare=%%A"
)

:: Function to check if Password Protected Sharing is enabled
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "everyoneincludesanonymous" >nul 2>&1
if %errorlevel%==0 (
    for /f "tokens=3" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "everyoneincludesanonymous"') do (
        set "passwordshare=%%A"
    )
)

:: Interpret registry value for Password Protected Sharing
if "!passwordshare!"=="1" (
    set "passStatus=Off"
) else (
    set "passStatus=On"
)

:: Display current status
cls
echo ==========================================
echo         Network File Sharing Status
echo ==========================================
echo Network Discovery       : !netdisc!
echo File and Printer Sharing: !fileshare!
echo Password Protection     : !passStatus!
echo.
echo 1. Enable
echo 2. Disable
echo 3. Refresh Status
echo 4. Exit
echo ==========================================
set /p choice=Select an option (1-4): 

if "%choice%"=="1" goto ENABLE
if "%choice%"=="2" goto DISABLE
if "%choice%"=="3" call "%~f0" & exit /b
if "%choice%"=="4" exit
goto MENU

:ENABLE
echo Enabling Network Discovery and File Sharing...

:: Enable Network Discovery
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes

:: Enable File and Printer Sharing
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes

:: Turn off password protected sharing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "everyoneincludesanonymous" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "restrictnullsessaccess" /t REG_DWORD /d 0 /f

echo Done!
pause
goto MENU

:DISABLE
echo Disabling Network Discovery and File Sharing...

:: Disable Network Discovery
netsh advfirewall firewall set rule group="Network Discovery" new enable=No

:: Disable File and Printer Sharing
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=No

:: Turn ON password protected sharing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "everyoneincludesanonymous" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "restrictnullsessaccess" /t REG_DWORD /d 1 /f

echo Done!
pause
goto MENU
