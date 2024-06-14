@echo OFF
SETLOCAL ENABLEDELAYEDEXPANSION

:: Check if running with administrative privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Script requires administrative privileges. Restarting with elevated permissions...
    echo.
    powershell -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"
    exit /b
)

cls
title Priority Modifier

echo Enter the executable file name:
set /p "executableName="

set "regKey=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%executableName%\PerfOptions"
set "regFolder=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%executableName%"

echo Select the operation:
echo 1. Set priority level
echo 2. Remove priority level

echo Enter the number corresponding to the desired operation:
set /p "operationOption="

IF "!operationOption!"=="1" (
    echo Select the priority level for CpuPriorityClass:
    echo 1. High
    echo 2. Above Normal
    echo 3. Normal
    echo 4. Below Normal
    echo 5. Low

    echo Enter the number corresponding to the desired priority level:
    set /p "priorityOption="

    if "!priorityOption!"=="1" (
        set "priorityValue=00000003"
    ) else if "!priorityOption!"=="2" (
        set "priorityValue=00000006"
    ) else if "!priorityOption!"=="3" (
        set "priorityValue=00000002"
    ) else if "!priorityOption!"=="4" (
        set "priorityValue=00000005"
    ) else if "!priorityOption!"=="5" (
        set "priorityValue=00000001"
    ) else (
        echo Invalid priority option selected.
    )
    reg add "!regKey!" /v "CpuPriorityClass" /t REG_DWORD /d 0x!priorityValue! /f
    if !errorlevel! equ 0 (
        echo Registry key and value added successfully.
    ) else (
        echo Failed to add registry key and value.
    )
) else if "!operationOption!"=="2" (
    set valueName=CpuPriorityClass
    reg delete "!regKey!" /v "CpuPriorityClass" /f
    if !errorlevel! equ 0 (
        echo Registry key and value removed successfully.
    ) else (
        echo Failed to remove registry key and value.
    )
    reg delete "!regFolder!" /f
    if !errorlevel! equ 0 (
        echo Registry folder removed successfully.
    ) else (
        echo Failed to remove registry folder.
    )
) else (
    echo Invalid operation option selected.
)

echo Press any key to exit.
pause > nul