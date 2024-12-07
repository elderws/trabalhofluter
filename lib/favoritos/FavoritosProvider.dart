import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FavoritosProvider extends ChangeNotifier {
  List<String> _favoritos = [];

  List<String> get favoritos => _favoritos;

  FavoritosProvider() {
    _loadFavoritos();
  }

  Future<void> _loadFavoritos() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/favoritos.txt');
    if (await file.exists()) {
      final contents = await file.readAsString();
      _favoritos = contents.split('\n').where((line) => line.isNotEmpty).toList();
      notifyListeners();
    }
  }

  Future<void> _saveFavoritos() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/favoritos.txt');
    await file.writeAsString(_favoritos.join('\n'));
  }

  void addFavorito(String favorito) {
    if (!_favoritos.contains(favorito)) {
      _favoritos.add(favorito);
      _saveFavoritos();
      notifyListeners();
    }
  }

  void removeFavorito(String favorito) {
    if (_favoritos.contains(favorito)) {
      _favoritos.remove(favorito);
      _saveFavoritos();
      notifyListeners();
    }
  }
}