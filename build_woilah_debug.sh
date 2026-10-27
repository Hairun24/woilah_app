#!/usr/bin/env bash
set -euo pipefail

# Ganti ini sesuai folder proyek Anda
REPO_DIR="${1:-$HOME/woilah_app}"

echo "=== Build Woilah Debug APK ==="
echo "Repo: $REPO_DIR"

# 1) Install dependency dasar
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y wget unzip git curl ca-certificates openjdk-17-jdk

# 2) Setup Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"

# 3) Setup Flutter
if [ ! -d "$HOME/flutter" ]; then
  git clone https://github.com/flutter/flutter.git "$HOME/flutter"
fi

grep -qxF 'export PATH="$PATH:$HOME/flutter/bin"' ~/.bashrc || \
  echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc

source ~/.bashrc
flutter --version

# 4) Setup Android SDK
SDK_DIR="$HOME/android-sdk"
mkdir -p "$SDK_DIR"

ZIP_PATH="$SDK_DIR/commandlinetools-linux-11076708_latest.zip"
if [ ! -f "$ZIP_PATH" ]; then
  wget -O "$ZIP_PATH" https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
fi

rm -rf /tmp/android-cmdline
mkdir -p /tmp/android-cmdline
unzip -o "$ZIP_PATH" -d /tmp/android-cmdline >/dev/null

mkdir -p "$SDK_DIR/cmdline-tools"
if [ -d "$SDK_DIR/cmdline-tools/latest" ]; then
  rm -rf "$SDK_DIR/cmdline-tools/latest"
fi

EXTRACTED_DIR="$(find /tmp/android-cmdline -maxdepth 2 -type d -name 'cmdline-tools*' | head -n 1 || true)"
if [ -z "$EXTRACTED_DIR" ]; then
  echo "ERROR: Android SDK extraction failed."
  exit 1
fi

mv "$EXTRACTED_DIR" "$SDK_DIR/cmdline-tools/latest"

export ANDROID_HOME="$HOME/android-sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

grep -qxF 'export ANDROID_HOME=$HOME/android-sdk' ~/.bashrc || \
  echo 'export ANDROID_HOME=$HOME/android-sdk' >> ~/.bashrc

grep -qxF 'export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"' ~/.bashrc || \
  echo 'export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"' >> ~/.bashrc

# 5) Install platform tools
yes | sdkmanager --licenses >/dev/null 2>&1 || true
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# 6) Build app
cd "$REPO_DIR"
echo "sdk.dir=$HOME/android-sdk" > android/local.properties

flutter pub get
flutter doctor
flutter build apk --debug

echo
echo "APK berhasil dibuat:"
echo "$REPO_DIR/build/app/outputs/flutter-apk/app-debug.apk"
