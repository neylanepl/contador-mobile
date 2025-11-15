import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/big_card.dart';

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

          // Input do step
          SizedBox(
            width: 220,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Valor do incremento",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              ),
              onChanged: (text) {
                final n = int.tryParse(text);
                if (n != null && n > 0) appState.setStep(n);
              },
            ),
          ),

          SizedBox(height: 20),

          // Botões
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'Decrementar',
                child: ElevatedButton(
                  onPressed: appState.decrement,
                  child: Icon(Icons.remove),
                ),
              ),
              SizedBox(width: 20),
              Tooltip(
                message: 'Incrementar',
                child: ElevatedButton(
                  onPressed: appState.increment,
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: appState.resetCounter,
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
