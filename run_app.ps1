param (
    [string]$Device = "chrome"
)

# Srekar's Fan Association - App Launch Script
# Automatically ensures build directory is isolated from OneDrive sync locks

$targetBuild = "$env:LOCALAPPDATA\Flutter_lab_build"

if (!(Test-Path $targetBuild)) {
    New-Item -ItemType Directory -Path $targetBuild -Force | Out-Null
}

if (!(Test-Path "build")) {
    cmd /c mklink /J "build" "$targetBuild" | Out-Null
}

# Clean any lingering flutter_assets lock before launch
if (Test-Path "build\flutter_assets") {
    Remove-Item -Recurse -Force "build\flutter_assets" -ErrorAction SilentlyContinue | Out-Null
}

Write-Host "🚀 Launching Srekar's Association 3D App on $Device..." -ForegroundColor Cyan

flutter run -d $Device
