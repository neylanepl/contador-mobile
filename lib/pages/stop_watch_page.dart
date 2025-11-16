import 'package:flutter/material.dart';
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter/services.dart';
import '../utils/logger.dart';

class StopwatchPage extends StatefulWidget {
  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  int? targetSeconds;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    logInfo('Cronômetro inicializado');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _confettiController.dispose();
    logDebug('Cronômetro descartado');
    super.dispose();
  }

  void _toggleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      _timer = null;
      logInfo('Cronômetro parado em ${_fmt(_stopwatch.elapsed)}');
    } else {
      _stopwatch.start();
      logInfo('Cronômetro iniciado');
      _timer = Timer.periodic(Duration(milliseconds: 30), (_) {
        if (mounted) setState(() {});

        if (targetSeconds != null) {
          final elapsed = _stopwatch.elapsed.inSeconds;

          if (elapsed >= targetSeconds!) {
            _stopwatch.stop();
            _timer?.cancel();

            logInfo('Meta alcançada: ${elapsed}s (meta ${targetSeconds}s)');
            _confettiController.play();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Meta alcançada! 🎉"),
                  backgroundColor: Colors.blue[800]),
            );

            Future.delayed(Duration(seconds: 2), () {
              if (mounted) _reset();
            });
          }
        }
      });
    }
    setState(() {});
  }

  void _reset() {
    logDebug('Cronômetro reiniciado a partir de ${_fmt(_stopwatch.elapsed)}');
    _stopwatch.reset();
    if (mounted) setState(() {});
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final cs =
        (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return "$h:$m:$s.$cs";
  }

  void _openTargetDialog() {
    final controller = TextEditingController(
      text: targetSeconds?.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (ctx) {
        logInfo('Abrir modal de meta');
        return AlertDialog(
          title: Text("Definir meta (segundos)"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Meta",
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                logDebug('Modal de meta cancelado');
                Navigator.pop(ctx);
              },
            ),
            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () {
                final n = int.tryParse(controller.text);
                if (n != null && n > 0) {
                  setState(() => targetSeconds = n);
                  logInfo('Meta definida para $n segundos');
                }
                Navigator.pop(ctx);
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildTimerDisplay() {
    return Text(
      _fmt(_stopwatch.elapsed),
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSlider(BuildContext context) {
    if (targetSeconds == null) return SizedBox.shrink();

    final secondsElapsed = _stopwatch.elapsed.inSeconds.toDouble();
    final sliderMax = targetSeconds!.toDouble();

    return SizedBox(
      width: 260,
      height: 260,
      child: SleekCircularSlider(
        min: 0,
        max: sliderMax,
        initialValue: secondsElapsed.clamp(0, sliderMax),
        appearance: CircularSliderAppearance(
          animationEnabled: false,
          customWidths: CustomSliderWidths(
            trackWidth: 10,
            progressBarWidth: 12,
          ),
          customColors: CustomSliderColors(
            trackColor: Colors.grey.shade300,
            progressBarColor: Theme.of(context).colorScheme.primary,
          ),
          infoProperties: InfoProperties(
            mainLabelStyle: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
            modifier: (_) => _fmt(_stopwatch.elapsed),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSlider(context),
                const SizedBox(height: 10),
                if (targetSeconds == null) _buildTimerDisplay(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      targetSeconds != null
                          ? "Meta: ${targetSeconds}s"
                          : "Nenhuma meta definida",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (targetSeconds != null)
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: InkWell(
                          onTap: () => setState(() => targetSeconds = null),
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleStartStop,
                      icon: Icon(
                        _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                      ),
                      label: Text(_stopwatch.isRunning ? "Pausar" : "Iniciar"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _reset,
                      icon: Icon(Icons.refresh),
                      label: Text("Resetar"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _openTargetDialog,
                      icon: Icon(Icons.flag_outlined),
                      label: Text("Meta"),
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
