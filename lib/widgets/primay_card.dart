import 'package:flutter/material.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
