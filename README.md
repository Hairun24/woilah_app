# Woilah

A Flutter app for reading manga, watching anime, and watching movies with extensible source-based content.

## Features
- Home screen with Manga, Anime, and Movie categories
- Search
- Detail screen
- Manga reader
- Video player
- Favorites
- Settings and source extension manager
- JavaScript-based extension runner
- Local persistent settings with SharedPreferences

## Tech stack
- Flutter
- Dart
- Provider
- SharedPreferences
- HTTP
- flutter_js
- extended_image
- media_kit

## Run locally
```bash
flutter pub get
flutter run
```

## Build release
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

## Android release signing
Set your keystore passwords in `android/key.properties` before building release.
