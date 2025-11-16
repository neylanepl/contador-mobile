import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../utils/logger.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${appState.counter}",
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _gridButton(
                          context,
                          icon: Icons.remove,
                          label: "Diminuir",
                          onTap: () {
                            logDebug('Botão diminuir foi pressionado');
                            appState.decrement();
                          },
                          showBottomLine: true,
                          showRightLine: true,
                        ),
                        _gridButton(
                          context,
                          icon: Icons.add,
                          label: "Somar",
                          onTap: () {
                            logDebug('Botão somar foi pressionado');
                            appState.increment();
                          },
                          showBottomLine: true,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _gridButton(
                          context,
                          icon: Icons.edit,
                          label: "Incremento",
                          onTap: () {
                            logInfo('Abrir modal de alteração do incremento');
                            _editStepDialog(context, appState);
                          },
                          showRightLine: true,
                        ),
                        _gridButton(
                          context,
                          icon: Icons.refresh,
                          label: "Resetar",
                          onTap: () {
                            logInfo('Botão reset foi pressionado');
                            appState.resetCounter();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool showRightLine = false,
    bool showBottomLine = false,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: showRightLine
                ? BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 1)
                : BorderSide.none,
            bottom: showBottomLine
                ? BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 1)
                : BorderSide.none,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.zero,
          onTap: onTap,
          child: SizedBox(
            height: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 34, color: theme.colorScheme.primary),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editStepDialog(BuildContext context, MyAppState appState) {
    final controller = TextEditingController(text: appState.step.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alterar incremento"),
          content: TextField(
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Incremento",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                logDebug('Modal de alteração cancelado');
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("Salvar"),
              onPressed: () {
                final n = int.tryParse(controller.text);
                if (n != null && n > 0) {
                  appState.setStep(n);
                  logInfo('Incremento salvo: $n');
                }
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
