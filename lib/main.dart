import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'utils/logger.dart';

void main() {
  AppLogger.init();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    logException('Erro do Flutter', details.exception, details.stack);
  };

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    logException('Erro não tratado', error, stack);
  });
}
