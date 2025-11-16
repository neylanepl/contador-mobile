import 'package:flutter/material.dart';
import '../utils/logger.dart';
import 'package:english_words/english_words.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  int counter = 0;
  int step = 1;

  MyAppState() {
    logVerbose('MyAppState inicializado com counter=$counter, step=$step');
  }

  void setStep(int newStep) {
    try {
      if (newStep <= 0) {
        logWarning('Tentativa de definir step inválido: $newStep');
        return;
      }
      final old = step;
      step = newStep;
      logInfo('Incremento alterado: $old -> $newStep');
      notifyListeners();
    } catch (e, stackTrace) {
      logError('Erro ao alterar step', e, stackTrace);
    }
  }

  void increment() {
    try {
      final before = counter;
      counter += step;
      logDebug('Incremento: $before + $step = $counter');
      notifyListeners();
    } catch (e, stackTrace) {
      logError('Erro ao incrementar contador', e, stackTrace);
    }
  }

  void decrement() {
    try {
      if (counter - step >= 0) {
        final before = counter;
        counter -= step;
        logDebug('Decremento: $before - $step = $counter');
        notifyListeners();
      } else {
        logWarning('Tentativa de decrementar abaixo de zero bloqueada (counter=$counter, step=$step, resultado seria ${counter - step})');
      }
    } catch (e, stackTrace) {
      logError('Erro ao decrementar contador', e, stackTrace);
    }
  }

  void resetCounter() {
    try {
      logInfo('Contador resetado de $counter para 0');
      counter = 0;
      notifyListeners();
    } catch (e, stackTrace) {
      logError('Erro ao resetar contador', e, stackTrace);
    }
  }
}
