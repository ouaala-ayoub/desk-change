import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gestionbureaudechange/models/core/user_creds.dart';
import 'package:gestionbureaudechange/providers/login_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
// import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'helper_widgets/styled_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ProgressHUD(
        child: listBody(context),
      ),
    );
  }

  Padding listBody(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<LoginProvider>(
        builder: (context, provider, widget) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 20),
              StyledTextField(
                hint: "Nom d'utilisateur",
                labelText: "Nom d'utilisateur",
                inputType: TextInputType.text,
                icon: const Icon(Icons.person),
                controller: provider.userNameController,
              ),
              const SizedBox(height: 20),
              StyledTextField(
                hint: 'Mot de passe',
                labelText: 'Mot de passe',
                inputType: TextInputType.visiblePassword,
                icon: const Icon(Icons.lock),
                error: provider.errorMessage,
                controller: provider.passwordController,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  final progress = ProgressHUD.of(context);
                  final creds = UserCredentiels(
                    userName: provider.userNameController.text,
                    password: provider.passwordController.text,
                  );
                  progress?.show();
                  context.read<LoginProvider>().login(
                    creds,
                    onLoginSuccess: (res) {
                      logger.d(res);
                      context.read<AuthProvider>().setAdmin(res);
                      progress?.dismiss();
                      context.go('/home');
                    },
                    onLoginFail: (e) {
                      logger.d(e);
                      context.read<AuthProvider>().setError(e);
                      progress?.dismiss();
                      provider.setErrorMessage(e.toString());
                    },
                  );
                },
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
