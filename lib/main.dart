import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'data/repositories/favorites_repository.dart';
import 'data/repositories/media_repository.dart';
import 'data/repositories/source_repository.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  final mediaRepository = MediaRepository();
  final favoritesRepository = FavoritesRepository();
  final sourceRepository = SourceRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>.value(value: settingsService),
        Provider<MediaRepository>.value(value: mediaRepository),
        Provider<FavoritesRepository>.value(value: favoritesRepository),
        Provider<SourceRepository>.value(value: sourceRepository),
      ],
      child: const App(),
    ),
  );
}
