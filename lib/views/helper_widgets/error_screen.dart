import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  final void Function() refreshFunction;
  const ErrorScreen(
      {required this.refreshFunction, super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (context.read<AuthProvider>().loading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                FilledButton(
                  onPressed: refreshFunction,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Refresh",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
            ]),
      ),
    );
  }
}
