@echo off
set TARGET_BUILD=%LOCALAPPDATA%\Flutter_lab_build
if not exist "%TARGET_BUILD%" mkdir "%TARGET_BUILD%"
if not exist "build" mklink /J "build" "%TARGET_BUILD%"
if exist "build\flutter_assets" rd /s /q "build\flutter_assets" 2>nul
echo 🚀 Launching Srekar's Association 3D App...
flutter run -d chrome %*
