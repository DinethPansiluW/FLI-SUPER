@echo off
:: Check if the script is running as Administrator
:: If not, it will restart itself with elevated privileges

:: Request admin privileges
:: ----------------------------------------
if "%1" neq "elevated" (
    echo This script requires administrative privileges.
    echo Please accept the UAC prompt when prompted.
    echo.
    echo Running as Administrator...
    :: Re-run the script with elevated privileges
    powershell -Command "Start-Process '%~0' -ArgumentList 'elevated' -Verb RunAs"
    exit /b
)


:: Define the path to the "AnyDesk" folder
set "targetFolder=%AppData%\AnyDesk"

:: Attempt to kill processes potentially locking the folder
echo Checking for processes that may lock the "AnyDesk"....
tasklist | find /i "AnyDesk.exe" >nul 2>&1
if %errorlevel% equ 0 (
    echo Killing AnyDesk process...
    taskkill /im "AnyDesk.exe" /f >nul 2>&1
)

:: Attempt to Reset "AnyDesk"
if exist "%targetFolder%" (
    echo Attempting to Reset "AnyDesk"...
    rd /s /q "%targetFolder%"

    :: Working to ensure deletion is processed
    timeout /t 2 /nobreak >nul
)

:: Attempt to Reset "AnyDesk"
if exist "%targetFolder%" (
    echo Attempting to Reset "AnyDesk"...
    rd /s /q "%targetFolder%"

    :: Working to ensure deletion is processed
    timeout /t 2 /nobreak >nul
)


DEL /F /S /Q "%USERPROFILE%\AppData\Local\Temp\*" >nul 2>nul && FOR /D %%P IN ("%USERPROFILE%\AppData\Local\Temp\*") DO RMDIR /S /Q "%%P" >nul 2>nul



:: Define the target directory for searching "AnyDesk" folders
set "driverStorePath=C:\Windows\System32\DriverStore\FileRepository"

:: Search for folders named "AnyDesk" in the DriverStore directory
echo Searching for "AnyDesk" Program...
for /d %%F in ("%driverStorePath%\*AnyDesk*") do (
    echo Working..
    takeown /f "%%F" /r /d y >nul 2>&1
    echo Working....
    icacls "%%F" /grant administrators:F /t /c /q >nul 2>&1
    echo Working......
    rd /s /q "%%F"
)

:: Verify if any "AnyDesk" folders remain in the DriverStore directory
set "foundAnyDesk=false"
for /d %%F in ("%driverStorePath%\*AnyDesk*") do (
    set "foundAnyDesk=true"
)

if "%foundAnyDesk%" == "true" (
    echo Action denied.
) else (
    echo Action successful
)

:: Search for files named "anydesk" in the DriverStore directory
echo Searching for "anydesk" extras..
for %%F in ("%driverStorePath%\*anydesk*") do (
    echo Working...
    takeown /f "%%F" /a >nul 2>&1
    echo Working.....
    icacls "%%F" /grant administrators:F /c /q >nul 2>&1
    echo Working.......
    del /f /q "%%F"
)

:: Verify if any "anydesk" files remain in the DriverStore directory
set "foundAnyDeskFile=false"
for %%F in ("%driverStorePath%\*anydesk*") do (
    set "foundAnyDeskFile=true"
)

if "%foundAnyDeskFile%" == "true" (
    echo Action denied..
) else (
    echo Action successful.
)


:: Recheck the directory
if exist "%targetFolder%" (
    echo Action Failed. Could not Reset "AnyDesk".
) else (
    echo Action successful. The "AnyDesk Reseted".
)


:: Wait for user input before exiting
echo.
pause
exit