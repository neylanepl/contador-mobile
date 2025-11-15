// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PrimaryCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const PrimaryCard({
    Key? key,
    required this.child,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    final width = maxWidth > 420 ? 420.0 : maxWidth;

    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: SizedBox(
        width: width,
        height: 420,
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
