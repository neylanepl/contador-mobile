import 'package:flutter/material.dart';
import 'dart:async';
import 'package:count_flow/widgets/primay_card.dart';

class ClockPage extends StatefulWidget {
  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late DateTime now;
  Timer? _timer;

  String selectedZone = "America/Sao_Paulo";
  final Map<String, int> zones = {
    "America/Sao_Paulo": -3,
    "America/New_York": -5,
    "Europe/London": 0,
    "Europe/Berlin": 1,
    "Asia/Tokyo": 9,
    "Australia/Sydney": 11,
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
      setState(() => now = DateTime.now().toUtc());
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
    final idx = adjustedTime.weekday - 1;
    return (idx >= 0 && idx < _weekdays.length) ? _weekdays[idx] : '';
  }

  String get _dateString {
    final t = adjustedTime;
    return '${_two(t.day)}/${_two(t.month)}/${t.year}';
  }

  IconData get _iconForPeriod {
    final hour = adjustedTime.hour;

    if (hour >= 5 && hour < 12) return Icons.wb_sunny_rounded;
    if (hour >= 12 && hour < 18) return Icons.wb_cloudy_rounded;
    return Icons.nightlight_round;
  }

  Color get _colorForPeriod {
    final hour = adjustedTime.hour;

    if (hour >= 5 && hour < 12) {
      return Colors.amber.shade600;
    }
    if (hour >= 12 && hour < 18) {
      return Colors.orange.shade600;
    }
    return Colors.blue.shade800;
  }

  String get _greeting {
    final hour = adjustedTime.hour;

    if (hour >= 5 && hour < 12) return "Bom dia!";
    if (hour >= 12 && hour < 18) return "Boa tarde!";
    return "Boa noite!";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.92,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedZone,
                  underline: SizedBox.shrink(),
                  items: zones.keys
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => selectedZone = v);
                  },
                ),
              ),
            ),
            SizedBox(height: 25),
            PrimaryCard(
              color: _colorForPeriod,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_iconForPeriod, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      _greeting,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      _timeString,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 52,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      _weekdayString,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _dateString,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
