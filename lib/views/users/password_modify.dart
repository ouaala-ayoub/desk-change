import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gestionbureaudechange/providers/password_modify_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../helper_widgets/styled_text_field.dart';

class PasswordModify extends StatelessWidget {
  final logger = Logger();
  final String id;
  PasswordModify({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change le mot de passe')),
      body: ProgressHUD(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<PasswordModifyProvider>(
            builder: (context, provider, child) => Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                StyledTextField(
                    hint: 'Nouveau mot de passe',
                    labelText: 'Nouveau mot de passe',
                    error: provider.passwordError,
                    controller: provider.passwordController),
                const SizedBox(
                  height: 20,
                ),
                StyledTextField(
                    hint: 'Re-tapez le mot de passe',
                    labelText: 'Re-tapez le mot de passe',
                    error: provider.retypedPasswordError,
                    controller: provider.retypedPasswordController),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                    onPressed: () {
                      final progress = ProgressHUD.of(context);
                      provider.changePassword(id, onStart: () {
                        progress?.show();
                      }, onSuccess: (res) {
                        logger.d(res);
                        progress?.dismiss();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Mot de passe changé avec succès')));
                        context.pop();
                      }, onFail: (e) {
                        logger.e(e);
                        progress?.dismiss();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          'Erreur innatendue',
                          style: TextStyle(color: Colors.red),
                        )));
                      });
                    },
                    child: const Text('Changer le mot de passe'))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
