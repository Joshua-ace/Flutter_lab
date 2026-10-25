#!/bin/bash
set -e

echo "🚀 ==============================================="
echo "🚀 Srekar's Fan Association - Vercel Build Script"
echo "🚀 ==============================================="

# 1. Install or update Flutter SDK
if [ ! -d "flutter" ]; then
  echo "📦 Cloning Flutter SDK (stable branch)..."
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git
else
  echo "📦 Existing Flutter directory found. Updating..."
  cd flutter && git pull && cd ..
fi

# 2. Add Flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"

echo "🔧 Flutter Version Info:"
flutter --version

echo "⚙️ Enabling web support..."
flutter config --enable-web

echo "📥 Getting dependencies..."
flutter pub get

echo "🏗️ Building Flutter Web release bundle..."
flutter build web --release

echo "✅ Build completed successfully! Output directory: build/web"
