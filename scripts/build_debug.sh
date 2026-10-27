#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "=== Woilah Debug Build ==="
flutter clean
flutter pub get
flutter build apk --debug

echo
echo "APK debug berhasil dibuat:"
echo "$ROOT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
