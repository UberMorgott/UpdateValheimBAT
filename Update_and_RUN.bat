@echo off
curl --user ModMan:4dyEtavmjFHZf5W -o "%~dp0wget.exe" -z "%~dp0wget.exe" -C - ftp://morgott.keenetic.pro/valheim/wget.exe
wget --user=ModMan --password=4dyEtavmjFHZf5W -q --show-progress -r -N -l inf --no-host-directories --no-parent --cut-dirs=1 ftp://morgott.keenetic.pro/valheim/
curl --user ModMan:4dyEtavmjFHZf5W --list-only ftp://morgott.keenetic.pro/Valheim/BepInEx/plugins/ > ftp_files_splurgeola.txt
set "keep_files=%~dp0ftp_files_splurgeola.txt"
set "path_to_delete=%~dp0BepInEx\plugins"

for /f "delims=" %%i in ('dir /b /a:d "%path_to_delete%"') do (
    findstr /i "\<%%i\>" "%keep_files%" >nul || (
        rmdir /s /q "%path_to_delete%\%%i" >nul
    )
)
for /f "delims=" %%i in ('dir /b "%path_to_delete%"') do (
    findstr /i "\<%%i\>" "%keep_files%" >nul || (
        del /f /q "%path_to_delete%\%%i" >nul
    )
)
del /f /q "%keep_files%"

start "" /high "%~dp0valheim.exe"
