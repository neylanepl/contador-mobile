import 'package:flutter/material.dart';
import '../utils/logger.dart';
import 'package:english_words/english_words.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  int counter = 0;
  int step = 1;

  void setStep(int newStep) {
    final old = step;
    step = newStep;
    logInfo('Incremento alterado: $old -> $newStep');
    notifyListeners();
  }

  void increment() {
    final before = counter;
    counter += step;
    logDebug('Incremento: $before + $step = $counter');
    notifyListeners();
  }

  void decrement() {
    if (counter - step >= 0) {
      final before = counter;
      counter -= step;
      logDebug('Decremento: $before - $step = $counter');
      notifyListeners();
    } else {
      logWarning('Tentativa de decrementar abaixo de zero (counter=$counter, step=$step)');
    }
  }

  void resetCounter() {
    logInfo('Contador resetado de $counter para 0');
    counter = 0;
    notifyListeners();
  }
}
