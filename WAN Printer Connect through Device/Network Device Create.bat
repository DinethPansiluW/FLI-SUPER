@echo off
setlocal

:: Get ESC character for ANSI codes
for /f "delims=" %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"

:: Set ANSI color codes
set "GREEN=[1;32m"
set "RED=[31m"
set "ORANGE=[33m"
set "PINK=[3;35m"
set "SKYBLUE=[96m"
set "RESET=[0m"

:: Enable ANSI colors in console
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    >"%temp%\getadmin.vbs" (
        echo Set UAC = CreateObject^("Shell.Application"^)
        echo UAC.ShellExecute "%~f0", "", "", "runas", 1
    )
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit
)

:: Enable file sharing settings
echo %SKYBLUE%Enabling File Sharing Settings...%RESET%

netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes >nul
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul

:: Enable public folder sharing and disable password protected sharing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v forceguest /t REG_DWORD /d 1 /f >nul
netsh advfirewall firewall set rule group="Public Folder Sharing" new enable=Yes >nul
powershell -Command "Set-NetFirewallRule -DisplayGroup 'Public Folder Sharing' -Enabled True -Profile Any" >nul 2>&1

:: Disable SMB1 and enforce 128-bit encryption
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0 /f >nul

:: Import print sharing fix from reg file manually
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f >nul

:: Show sharing status
echo.
echo %GREEN%File Sharing - Enabled%RESET%
echo %GREEN%Public Folder Sharing - Enabled%RESET%
echo %GREEN%Password Protected Sharing - Disabled%RESET%
echo %GREEN%Print Sharing Fix Applied (RpcAuthnLevelPrivacyEnabled=0)%RESET%
echo.

:: Instructions
echo %SKYBLUE%To connect to another PC:%RESET%
echo %PINK%(Both devices must be on the same network)%RESET%
echo %GREEN%1. Press Win+R and type 'cmd'%RESET%
echo %GREEN%2. In CMD, type 'ipconfig' and press Enter%RESET%
echo %GREEN%3. Look for the IPv4 address (e.g., 192.168.1.XX)%RESET%
echo %ORANGE%Use that address to access shared folders%RESET%
echo.

:: Ask user for IP and shortcut name
set /p ip=%RESET%Enter the IP address of the second PC: %SKYBLUE%
set /p scname=%RESET%Enter a name for the desktop shortcut: %SKYBLUE% 

:: Create desktop shortcut
set "target=\\%ip%"
set "shortcut=%USERPROFILE%\Desktop\%scname%.lnk"

echo %SKYBLUE%Creating shortcut "%scname%"...%RESET%

powershell -command ^
$WshShell = New-Object -ComObject WScript.Shell; ^
$Shortcut = $WshShell.CreateShortcut('%shortcut%'); ^
$Shortcut.TargetPath = '%target%'; ^
$Shortcut.Save()

echo %GREEN%Shortcut created successfully on Desktop!%RESET%
pause
