import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/main.dart';
import 'package:gestionbureaudechange/providers/auth_provider.dart';
import 'package:gestionbureaudechange/providers/login_provider.dart';
import 'package:gestionbureaudechange/views/home_page.dart';
import 'package:gestionbureaudechange/views/login_page.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthProvider>().getUserAuth();
  }

  @override
  Widget build(BuildContext context) {
    //! error here
    final provider = context.read<AuthProvider>();
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, value, child) {
          return provider.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.auth.fold((e) {
                  logger.e("folding left ${e.toString()}");
                  if (e["resMessage"] != null) {
                    return ChangeNotifierProvider(
                      create: (context) => LoginProvider(),
                      child: const LoginPage(),
                    );
                  } else {
                    return ErrorScreen(
                      message: "Erreur innatendue",
                      refreshFunction:
                          context.read<AuthProvider>().getUserAuth(),
                    );
                  }
                }, (r) {
                  return const HomePage();
                });
        },
      ),
    );
  }
}

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
