import 'package:flutter/material.dart';
import '../pages/generator_page.dart';
import '../pages/clock_page.dart';
import '../pages/stop_watch_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = StopwatchPage();
        break;
      case 2:
        page = ClockPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Contador",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: true,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.calculate),
                        label: Text('Contador'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.timer),
                        label: Text('Cronômetro'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.access_time),
                        label: Text('Relógio'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() => selectedIndex = value);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Contador",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: page,
          ),
          bottomNavigationBar: SafeArea(
            child: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) =>
                  setState(() => selectedIndex = value),
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.calculate), label: 'Contador'),
                NavigationDestination(
                    icon: Icon(Icons.timer), label: 'Cronômetro'),
                NavigationDestination(
                    icon: Icon(Icons.access_time), label: 'Relógio'),
              ],
            ),
          ),
        );
      },
    );
  }
}
