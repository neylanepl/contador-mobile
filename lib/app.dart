import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'pages/home_page.dart';
import 'utils/logger.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logInfo('Construindo MyApp');
    return ChangeNotifierProvider(
      create: (context) {
        logInfo('Criando instância de MyAppState');
        return MyAppState();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contador',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
