@echo off

curl --user ModMan:4dyEtavmjFHZf5W -o "%~dp0rclone.exe" -z "%~dp0rclone.exe" -C - ftp://morgott.keenetic.pro/valheim/rclone.exe

rclone copy ":ftp,host=morgott.keenetic.pro,user=ModMan,pass=QFYBhRyu0vXuXfQNONI6KhnMK1iYzaZClOwNbLgegg:valheim/" "." --exclude "rclone.exe"  --config NUL --progress
rclone sync ":ftp,host=morgott.keenetic.pro,user=ModMan,pass=QFYBhRyu0vXuXfQNONI6KhnMK1iYzaZClOwNbLgegg:Valheim/BepInEx/plugins/" "BepInEx/plugins/"  --config NUL --progress

start "" "valheim.exe" -high
