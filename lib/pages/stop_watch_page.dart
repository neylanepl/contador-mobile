import 'package:flutter/material.dart';
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:count_flow/widgets/primay_card.dart';

class StopwatchPage extends StatefulWidget {
  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

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
        if (mounted) setState(() {});
        if (targetSeconds != null) {
          final elapsedSec = _stopwatch.elapsed.inSeconds;
          if (elapsedSec >= targetSeconds!) {
            _stopwatch.stop();
            _timer?.cancel();
            _confettiController.play();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Meta alcançada! 🎉")),
            );

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
    if (!mounted) return;
    setState(() {});
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final c = (d.inMilliseconds.remainder(1000) / 10)
        .floor()
        .toString()
        .padLeft(2, '0');
    return "$h:$m:$s.$c";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = _formatDuration(_stopwatch.elapsed);
    final running = _stopwatch.isRunning;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
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
                      Icon(Icons.timer, size: 56, color: Colors.white),
                      SizedBox(height: 12),
                      Text(display,
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 44,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 16),
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
                      targetSeconds = (n != null && n > 0) ? n : null;
                    },
                  ),
                ),
                SizedBox(height: 16),
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
