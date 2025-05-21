import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  var favoritesWords = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favoritesWords.contains(current)) {
      favoritesWords.remove(current);
    } else {
      favoritesWords.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    if (favoritesWords.contains(pair)) {
      favoritesWords.remove(pair);
      notifyListeners();
    }
  }
}
