import 'package:flutter/material.dart';
import '../pages/generator_page.dart';
import '../pages/clock_page.dart';
import '../pages/stop_watch_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    GeneratorPage(),
    StopwatchPage(),
    ClockPage(),
  ];

  final List<String> pageTitles = [
    'Contador',
    'Cronômetro',
    'Relógio',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          pageTitles[selectedIndex],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) {
          setState(() => selectedIndex = i);
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.exposure), label: 'Contador'),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Cronômetro'),
          NavigationDestination(
              icon: Icon(Icons.access_time), label: 'Relógio'),
        ],
      ),
    );
  }
}
