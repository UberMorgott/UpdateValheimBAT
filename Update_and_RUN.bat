@echo off
chcp 65001 > nul

::::Wget::::

set "url=https://eternallybored.org/misc/wget/1.21.1/64/wget.exe"
set "url_backup=https://eternallybored.org/misc/wget/1.21.4/64/wget.exe"
set "attempts=3"
set /a count=0
set "downloaded=0"

where wget >nul 2>nul
if %errorlevel% neq 0 goto :download_wget
goto :mods

:download_wget
echo wget не найден. Пытаемся скачать wget...

:download_attempt
set /a count+=1
echo Попытка %count% из %attempts%...
powershell -Command "try { Invoke-WebRequest -Uri '%url%' -OutFile '%~dp0wget.exe' -ErrorAction Stop } catch { exit 1 }"
if %errorlevel% equ 0 (
    echo wget успешно скачан.
    set "downloaded=1"
    goto :mods
) else (
    echo Не удалось скачать wget с основной ссылки.
)

if %count% lss %attempts% (
    goto :download_attempt
)

echo Пробуем скачать другую версию wget...
powershell -Command "try { Invoke-WebRequest -Uri '%url_backup%' -OutFile '%~dp0wget.exe' -ErrorAction Stop } catch { exit 1 }"
if %errorlevel% equ 0 (
    echo wget успешно скачан с запасной ссылки.
    set "downloaded=1"
    goto :mods
) else (
    echo Не удалось скачать wget с запасной ссылки.
    goto :manual_download
)

:manual_download
	echo 	Не удалось скачать wget автоматически.
	echo 	Пожалуйста, зайдите на https://eternallybored.org/misc/wget/ и скачайте wget.exe самостоятельно.
	echo 	Сохраните его в ту же папку, где находится этот скрипт.
	echo 	Для выхода нажмите любую клавишу.
    pause >nul
    exit

::::Обновляем моды::::

:mods
echo Скачиваем или обновляем моды.
cd /d "%~dp0"
set /a count=0
set "downloaded=0"

:download_attemptm
set /a count+=1
echo Попытка скачивания модов %count% из %attempts%...

wget --user=ModMan --password=4dyEtavmjFHZf5W -q --show-progress -r -N -l inf --no-host-directories --no-parent --cut-dirs=1 ftp://morgott.keenetic.pro/
if %errorlevel% equ 0 (
    echo Моды успешно скачаны или обновлены.
    set "downloaded=1"
    goto :end
) else (
    echo Ошибка при загрузке модов. Повторная попытка...
)

if %count% lss %attempts% (
    timeout /t 5 >nul
    goto :download_attemptm
)

if %downloaded% equ 0 (
    echo Подключиться к серверу обновлений никак не удаётся, обратись к Morgott с этой ошибкой.
    echo Нажмите любую клавишу для выхода...
    pause >nul
    exit
)

::::Удаляем мусор::::

curl --user ModMan:4dyEtavmjFHZf5W --list-only ftp://morgott.keenetic.pro/BepInEx/plugins/ > ftp_files.txt
set "keep_files=%~dp0curl_log.txt"
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
del /f /q "%~dp0curl_log.txt"
