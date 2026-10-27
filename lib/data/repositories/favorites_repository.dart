import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const String _key = 'favorites';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> toggleFavorite(String mediaId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (favorites.contains(mediaId)) {
      favorites.remove(mediaId);
    } else {
      favorites.add(mediaId);
    }

    await prefs.setStringList(_key, favorites);
  }
}
