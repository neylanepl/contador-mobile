import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

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
  int step = 1; // valor do incremento/decremento

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

  // Word generator & favorites (mantido do template)
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

/// PrimaryCard: reusable card with consistent sizing and primary color.
class PrimaryCard extends StatelessWidget {
  final Widget child;
  const PrimaryCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    final width = maxWidth > 420 ? 420.0 : maxWidth;
    return Card(
      color: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: SizedBox(
        width: width,
        height: 220,
        child: Center(
            child: Padding(padding: const EdgeInsets.all(12.0), child: child)),
      ),
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

  // Pequena lista de fusos com offset em horas em relação ao UTC
  String selectedZone = "America/Sao_Paulo";
  final Map<String, int> zones = {
    "America/Sao_Paulo": -3,
    "America/New_York": -5,
    "Europe/London": 0,
    "Europe/Berlin": 1,
  };

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
    now = DateTime.now().toUtc();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now().toUtc();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  DateTime get adjustedTime {
    final offset = zones[selectedZone] ?? 0;
    return now.add(Duration(hours: offset));
  }

  String get _timeString {
    final t = adjustedTime;
    return '${_two(t.hour)}:${_two(t.minute)}:${_two(t.second)}';
  }

  String get _weekdayString {
    final idx = adjustedTime.weekday - 1; // Monday = 1
    if (idx >= 0 && idx < _weekdays.length) return _weekdays[idx];
    return '';
  }

  String get _dateString {
    final t = adjustedTime;
    return '${_two(t.day)}/${_two(t.month)}/${t.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStyle = theme.textTheme.displayLarge?.copyWith(
          fontSize: 48,
          color: Colors.white,
        ) ??
        TextStyle(fontSize: 48, color: Colors.white);
    final dayStyle = theme.textTheme.titleLarge?.copyWith(
          fontSize: 20,
          color: Colors.white,
        ) ??
        TextStyle(fontSize: 20, color: Colors.white);

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PrimaryCard(
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
                  Text(_timeString,
                      style: timeStyle,
                      semanticsLabel: 'Hora atual $_timeString'),
                  SizedBox(height: 12),
                  Text(_weekdayString,
                      style: dayStyle,
                      semanticsLabel: 'Dia da semana $_weekdayString'),
                  SizedBox(height: 8),
                  Text(_dateString,
                      style: dayStyle, semanticsLabel: 'Data $_dateString'),
                ],
              ),
            ),

            // Dropdown de fusos
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedZone,
                underline: SizedBox.shrink(),
                items: zones.keys
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => selectedZone = v);
                },
              ),
            ),
          ],
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

  // Meta e confete
  int? targetSeconds;
  final TextEditingController targetController = TextEditingController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _confettiController.dispose();
    targetController.dispose();
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
        if (mounted) {
          setState(() {
            // atualiza a tela a cada tick
          });
        }
        // checa meta
        if (targetSeconds != null) {
          final elapsedSec = _stopwatch.elapsed.inSeconds;
          if (elapsedSec >= targetSeconds!) {
            // meta alcançada
            _stopwatch.stop();
            _timer?.cancel();
            _confettiController.play();

            // mostrar snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Meta alcançada! 🎉")),
            );

            // reset após pequena pausa
            Future.delayed(Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _reset();
                  targetSeconds = null;
                  targetController.clear();
                });
              }
            });
          }
        }
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
        ) ??
        TextStyle(fontSize: 44, color: Colors.white);

    final running = _stopwatch.isRunning;
    final display = _formatDuration(_stopwatch.elapsed);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
          ),
        ),

        // Conteúdo principal
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer,
                          size: 56,
                          color: Colors.white,
                          semanticLabel: 'Ícone de cronômetro'),
                      SizedBox(height: 12),
                      Text(display,
                          style: timeStyle,
                          semanticsLabel: 'Cronômetro $display'),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // INPUT META (segundos)
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Meta (segundos)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                    ),
                    onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null && n > 0) {
                        targetSeconds = n;
                      } else {
                        targetSeconds = null;
                      }
                    },
                  ),
                ),

                SizedBox(height: 16),

                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
      ],
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final value = appState.counter;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(value: value),
          SizedBox(height: 20),

          // INPUT DO STEP
          SizedBox(
            width: 220,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Valor do incremento",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              ),
              onChanged: (text) {
                final n = int.tryParse(text);
                if (n != null && n > 0) {
                  appState.setStep(n);
                }
              },
            ),
          ),

          // BOTOES
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'Decrementar',
                child: ElevatedButton(
                  onPressed: () {
                    appState.decrement();
                  },
                  child: Icon(Icons.remove),
                ),
              ),
              SizedBox(width: 20),
              Tooltip(
                message: 'Incrementar',
                child: ElevatedButton(
                  onPressed: () {
                    appState.increment();
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // RESET
          ElevatedButton.icon(
            onPressed: () => appState.resetCounter(),
            icon: Icon(Icons.restart_alt),
            label: Text("Zerar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
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
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium?.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 36,
    );
    return PrimaryCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calculate,
            size: 56,
            color: Colors.white,
            semanticLabel: 'Ícone de contador',
          ),
          SizedBox(height: 12),
          Text(
            value.toString(),
            style: style,
            semanticsLabel: 'Contador $value',
          ),
        ],
      ),
    );
  }
}
