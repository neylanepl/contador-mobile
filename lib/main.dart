import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
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

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // Contador
  int counter = 0;

  void increment() {
    counter++;
    notifyListeners();
  }

  void decrement() {
    if (counter > 0) {
      counter--;
      notifyListeners();
    }
  }

  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // ↓ Add the code below.
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
        // Wide layout: show NavigationRail on the left
        if (constraints.maxWidth >= 600) {
          return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    "Contador",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: true,
                    destinations: [
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
                      setState(() {
                        selectedIndex = value;
                      });
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

        // Narrow layout: show content and a bottom NavigationBar
        return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    "Contador",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.calculate),
                  label: 'Contador',
                ),
                NavigationDestination(
                  icon: Icon(Icons.timer),
                  label: 'Cronômetro',
                ),
                NavigationDestination(
                  icon: Icon(Icons.access_time),
                  label: 'Relógio',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class ClockPage extends StatefulWidget {
  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late DateTime now;
  Timer? _timer;

  static const _weekdays = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String get _timeString => '${_two(now.hour)}:${_two(now.minute)}:${_two(now.second)}';

  String get _weekdayString {
    // DateTime.weekday: Monday = 1, Sunday = 7
    final idx = now.weekday - 1;
    if (idx >= 0 && idx < _weekdays.length) return _weekdays[idx];
    return '';
  }

  String get _dateString => '${_two(now.day)}/${_two(now.month)}/${now.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStyle = theme.textTheme.displayLarge?.copyWith(
          fontSize: 48,
          color: Colors.white,
        ) ?? TextStyle(fontSize: 48, color: Colors.white);
    final dayStyle = theme.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          color: Colors.white,
        ) ?? TextStyle(fontSize: 20, color: Colors.white);

    return Center(
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 56,
                color: Colors.white,
                semanticLabel: 'Ícone de relógio',
              ),
              SizedBox(height: 12),
              Text(_timeString, style: timeStyle, semanticsLabel: 'Hora atual $_timeString'),
              SizedBox(height: 12),
              Text(_weekdayString, style: dayStyle, semanticsLabel: 'Dia da semana $_weekdayString'),
              SizedBox(height: 8),
              Text(_dateString, style: dayStyle, semanticsLabel: 'Data $_dateString'),
            ],
          ),
        ),
      ),
    );
  }
}

class StopwatchPage extends StatefulWidget {
  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _toggleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      _timer = null;
    } else {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: 30), (_) {
        // just rebuild to update display
        if (mounted) setState(() {});
      });
    }
    setState(() {});
  }

  void _reset() {
    _stopwatch.reset();
    if (!_stopwatch.isRunning) {
      setState(() {});
    }
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    final centis = (d.inMilliseconds.remainder(1000) / 10).floor();
    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');
    final cStr = centis.toString().padLeft(2, '0');
    return '$hStr:$mStr:$sStr.$cStr';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStyle = theme.textTheme.displayLarge?.copyWith(
          fontSize: 44,
          color: Colors.white,
        ) ?? TextStyle(fontSize: 44, color: Colors.white);

    final running = _stopwatch.isRunning;
    final display = _formatDuration(_stopwatch.elapsed);

    return Center(
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer, size: 56, color: Colors.white, semanticLabel: 'Ícone de cronômetro'),
              SizedBox(height: 12),
              Text(display, style: timeStyle, semanticsLabel: 'Cronômetro $display'),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _toggleStartStop,
                    icon: Icon(running ? Icons.pause : Icons.play_arrow),
                    label: Text(running ? 'Pausar' : 'Iniciar'),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _reset,
                    icon: Icon(Icons.refresh),
                    label: Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // Use the counter from appState
    final value = appState.counter;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(value: value),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.decrement();
                },
                icon: Icon(Icons.remove),
                label: Text('Decrementar'),
              ),
              SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: () {
                  appState.increment();
                },
                icon: Icon(Icons.add),
                label: Text('Incrementar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.value,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);       // ← Add this.
    // ↓ Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 36,
    );
    return Card(
      color: theme.colorScheme.primary,    // ← And also this.
      child: Padding(
        padding: const EdgeInsets.all(20),
        // ↓ Make the following change.
        child: Text(
          value.toString(),
          style: style,
          semanticsLabel: "Counter: $value",
        ),
      ),
    );
  }
}


