// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import '../utils/logger.dart';

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
    try {
      Theme.of(context);
      final screenWidth = MediaQuery.of(context).size.width;
      final maxWidth = screenWidth * 0.8;
      final width = maxWidth > 420 ? 420.0 : maxWidth;

      logVerbose('PrimaryCard criado (screenWidth=$screenWidth, calculatedWidth=$width, color=$color)');

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
    } catch (e, stackTrace) {
      logError('Erro ao construir PrimaryCard', e, stackTrace);
      // Retorna um widget de fallback em caso de erro
      return Card(
        child: SizedBox(
          width: 300,
          height: 420,
          child: Center(
            child: Text('Erro ao carregar card'),
          ),
        ),
      );
    }
  }
}
