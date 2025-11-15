import 'package:flutter/material.dart';
import 'package:count_flow/widgets/primay_card.dart';

class BigCard extends StatelessWidget {
  final int value;

  const BigCard({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium?.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 36,
    );

    return PrimaryCard(
      color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calculate, size: 56, color: Colors.white),
          SizedBox(height: 12),
          Text(
            value.toString(),
            style: style,
          ),
        ],
      ),
    );
  }
}
