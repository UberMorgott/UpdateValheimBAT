@echo off
chcp 65001 > nul

REM ЧЕКАЕМ Valheim.exe ==--

if not exist "%~dp0Valheim.exe" (
    echo Перенесите данный скрипт в папку, где есть Valheim.exe.
    pause >nul
    exit
)

REM ЧЕКАЕМ GIT ==--

if not exist "%~dp0Git" (
    curl -LO https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/MinGit-2.42.0.2-64-bit.zip && powershell.exe -nologo -noprofile -command "Expand-Archive -Path '.\*.zip' -DestinationPath '%~dp0Git'"
    del MinGit-2.42.0.2-64-bit.zip
    goto check
) else (
    goto check   
)

REM Удаляем старые сборки ==--

:check

if exist .gitignore goto check2
goto del

:check2
dir /ad .git > nul
if %errorlevel% equ 0 goto update

:del
set "keep_files=MonoBleedingEdge valheim_Data SteamOverlay64.dll steam_appid.txt unins000.dat UnityCrashHandler64.exe UnityPlayer.dll valheim.exe %~nx0 Git"

for /f "delims=" %%i in ('dir /b /a:d') do (
    echo "%keep_files%" | findstr /i "\<%%i\>" >nul || (
        rmdir /s /q "%%i" >nul
    )
)

for /f "delims=" %%i in ('dir /b') do (
    echo "%keep_files%" | findstr /i "\<%%i\>" >nul || (   
        del /f /q "%%i" >nul
    )
)

REM ОБНОВЛЯЕМ МОДЫ ==--

:update 

git\cmd\git.exe init
git config --global init.defaultBranch main
git\cmd\git.exe remote add origin https://github.com/UberMorgott/VMP.git
git\cmd\git.exe pull origin main
git\cmd\git.exe checkout .


REM ИГРАЕМ ==--

start valheim
