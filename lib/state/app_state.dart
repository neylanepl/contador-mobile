import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  int counter = 0;
  int step = 1;

  void setStep(int newStep) {
    step = newStep;
    notifyListeners();
  }

  void increment() {
    counter += step;
    notifyListeners();
  }

  void decrement() {
    if (counter - step >= 0) {
      counter -= step;
      notifyListeners();
    }
  }

  void resetCounter() {
    counter = 0;
    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
