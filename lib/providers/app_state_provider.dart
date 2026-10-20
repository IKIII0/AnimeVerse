import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/anime.dart';
import '../data/dummy_data.dart';

class AppStateProvider extends ChangeNotifier {
  //Data yang ingin disimpan di sini
  List<Anime> _favorites = [];

  // Kunci penyimpanan
  static const String _storageKey = 'favorite_anime_list';

  // Constructor: otomatis memuat favorit saat provider dibuat
  AppStateProvider() {
    _loadFavorites();
  }

  // getters
  List<Anime> get favorites => _favorites;

  // STATE BARU: genre yang dipilih (default "All")
  String _selectedGenre = "All";

  // GETTER BARU
  String get selectedGenre => _selectedGenre;

  // METHOD BARU: mengubah genre yang dipilih
  void setSelectedGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners(); // Beri tahu HomeScreen & GenreList
  }

  // STATE BARU: query pencarian (dipisah per layar)
  String _homeSearchQuery = '';
  String _favoriteSearchQuery = '';

  String get homeSearchQuery => _homeSearchQuery;
  String get favoriteSearchQuery => _favoriteSearchQuery;

  /// Update query pencarian HomeScreen
  void setHomeSearchQuery(String query) {
    _homeSearchQuery = query;
    notifyListeners();
  }

  /// Update query pencarian FavoriteScreen
  void setFavoriteSearchQuery(String query) {
    _favoriteSearchQuery = query;
    notifyListeners();
  }

  //helper functions untuk tahu apakah anime sudah ada di favorite atau belum
  bool isFavorite(String id) {
    return _favorites.any((anime) => anime.id == id);
  }

  void toggleFavorite(Anime anime) {
    if (isFavorite(anime.id)) {
      removeFavorite(anime.id);
    } else {
      addFavorite(anime);
    }
  }

  // fungsi untuk menambahkan dan menghapus anime dari daftar favorit
  void removeFavorite(String animeId) {
    _favorites.removeWhere((anime) => anime.id == animeId);
    _saveFavorites(); // Tambahkan, untuk menyimpan data ke SharedPreferences
    notifyListeners();
  }

  void addFavorite(Anime anime) {
    if (!isFavorite(anime.id)) {
      _favorites.add(anime);
      _saveFavorites(); // Tambahkan, untuk menyimpan data ke SharedPreferences
      notifyListeners();
    }
  }

  // Ambil daftar anime Home yang sudah difilter
  List<Anime> getFilteredAnimeForHome() {
    List<Anime> result = DummyData.animeList;

    // Terapkan filter genre
    if (_selectedGenre != "All") {
      result = result.where((anime) {
        // Pecah "Action, Adventure" menjadi ["Action", "Adventure"]
        final genres = anime.genre.split(',').map((g) => g.trim()).toList();
        // Cek apakah anime punya genre yang dipilih
        return genres.contains(_selectedGenre);
      }).toList();
    }

    // TERAPKAN FILTER SEARCH (setelah filter genre)
    if (_homeSearchQuery.isNotEmpty) {
      result = result.where((anime) {
        // Bandingkan dalam lowercase agar case-insensitive
        return anime.title.toLowerCase().contains(
          _homeSearchQuery.toLowerCase(),
        );
      }).toList();
    }

    return result;
  }

  // Ambil favorit yang sudah difilter (berdasarkan pencarian favorit)
  List<Anime> getFilteredFavorites() {
    List<Anime> result = _favorites; // Mulai dari daftar favorit

    // TERAPKAN FILTER SEARCH FAVORIT
    if (_favoriteSearchQuery.isNotEmpty) {
      result = result.where((anime) {
        return anime.title.toLowerCase().contains(
          _favoriteSearchQuery.toLowerCase(),
        );
      }).toList();
    }

    return result;
  }

  // Simpan daftar favorit ke SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. List<Anime> -> List<Map<String, dynamic>>
      final List<Map<String, dynamic>> favoritesJson = _favorites
          .map((anime) => anime.toJson())
          .toList();

      // 2. List<Map> -> String JSON, lalu simpan
      await prefs.setString(_storageKey, jsonEncode(favoritesJson));
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  // Muat daftar favorit dari SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Baca String JSON
      final String? favoritesJson = prefs.getString(_storageKey);

      if (favoritesJson != null) {
        // 2. String JSON -> List<dynamic>
        final List<dynamic> decoded = jsonDecode(favoritesJson);

        // 3. List<dynamic> -> List<Anime>
        _favorites = decoded
            .map((item) => Anime.fromJson(item as Map<String, dynamic>))
            .toList();

        notifyListeners(); // Beri tahu UI bahwa data sudah dimuat
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }
}
