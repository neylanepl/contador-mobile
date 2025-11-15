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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  Icon(Icons.access_time, size: 56, color: Colors.white),
                  SizedBox(height: 12),
                  Text(_timeString,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 48,
                        color: Colors.white,
                      )),
                  SizedBox(height: 12),
                  Text(_weekdayString,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                  SizedBox(height: 8),
                  Text(_dateString,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
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
                  if (v != null) setState(() => selectedZone = v);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
