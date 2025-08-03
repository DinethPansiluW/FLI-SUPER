@echo off
echo Applying printer settings...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "ConfigModule" /t REG_SZ /d "PrintConfig.dll" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "MajorVersion" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "MinorVersion" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "PriorityClass" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "RemoveMPDW" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "RemoveMXDW" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "ThrowDriverException" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "BeepEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "PortThreadPriority" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "SchedulerThreadPriority" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "GMTAdjustedForDST" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v "RpcAuthnLevelPrivacyEnabled" /t REG_DWORD /d 0 /f

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows 4.0" /v "Directory" /t REG_SZ /d "WIN40" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows ARM64" /v "Directory" /t REG_SZ /d "ARM64" /f

echo Registry changes applied successfully.
pause
