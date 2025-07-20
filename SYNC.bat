@echo off
start "" "D:\Supervision\Sync\AutoSync.exe"
start "" "D:\Supervision\Sync\fli_Invoice_Sync.exe"
start "" "D:\Supervision\Sync\fli_server_sync.exe"
start "" "D:\Supervision\Sync\server_dashboard.exe"

timeout /t 2 /nobreak >nul

taskkill /im server_dashboard.exe /f

exit
