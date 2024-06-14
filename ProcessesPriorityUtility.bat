@echo off
setlocal

:: Check if running with administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Script requires administrative privileges. Restarting with elevated permissions...
    echo.
    powershell Start-Process -FilePath "%0" -Verb RunAs
    exit /b
)

setlocal enabledelayedexpansion

set /p "executableName=Enter the executable file name: "

echo Select the priority level for CpuPriorityClass:
echo 1. High
echo 2. Above Normal
echo 3. Normal
echo 4. Below Normal
echo 5. Low

set /p "priorityOption=Enter the number corresponding to the desired priority level: "

if %priorityOption% equ 1 (
    set "priorityValue=00000003"
) else if %priorityOption% equ 2 (
    set "priorityValue=00000006"
) else if %priorityOption% equ 3 (
    set "priorityValue=00000002"
) else if %priorityOption% equ 4 (
    set "priorityValue=00000005"
) else if %priorityOption% equ 5 (
    set "priorityValue=00000001"
) else (
    echo Invalid priority option selected.
    exit /b
)

set "regKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%executableName%\PerfOptions"
set "valueName=CpuPriorityClass"

reg add "%regKey%" /v "%valueName%" /t REG_DWORD /d 0x!priorityValue! /f
if !errorlevel! equ 0 (
    echo Registry key and value added successfully.
) else (
    echo Failed to add registry key and value.
)
pause