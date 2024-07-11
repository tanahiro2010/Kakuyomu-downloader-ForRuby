@echo off
:: Check if Git is installed
git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Git is already installed.
    goto end
)

:: Check if Chocolatey is installed
choco -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Chocolatey is not installed. Installing Chocolatey...
    @powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Set-ExecutionPolicy AllSigned; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    if %errorlevel% neq 0 (
        echo Failed to install Chocolatey. Exiting...
        exit /b 1
    )
)

:: Install Git using Chocolatey
echo Installing Git...
choco install git -y
if %errorlevel% neq 0 (
    echo Failed to install Git. Exiting...
    exit /b 1
)

echo Git has been successfully installed.

:end

git clone https://github.com/tanahiro2010/Kakuyomu-downloader
cd Kakuyomu-downloader
start
pause