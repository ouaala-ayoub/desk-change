import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/main.dart';
import 'package:gestionbureaudechange/providers/auth_provider.dart';
import 'package:gestionbureaudechange/providers/login_provider.dart';
import 'package:gestionbureaudechange/views/home_page.dart';
import 'package:gestionbureaudechange/views/login_page.dart';
import 'package:provider/provider.dart';

import 'helper_widgets/error_screen.dart';

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
