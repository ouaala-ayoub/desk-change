import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gestionbureaudechange/providers/user_add_provider.dart';
import 'package:gestionbureaudechange/views/desks/desk_add.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/core/user/desk.dart';
import '../helper_widgets/styled_text_field.dart';

class UserAddPage extends StatefulWidget {
  const UserAddPage({super.key});

  @override
  State<UserAddPage> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserAddProvider>().getDesks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un utilisateur')),
      body: ProgressHUD(
        child: Consumer<UserAddProvider>(
          builder: (context, value, child) {
            return value.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : value.desks.fold(
                    (l) => Center(
                          child: Text('$l'),
                        ),
                    (r) => userForm(context, value, r));
          },
        ),
      ),
    );
  }

  Padding userForm(
      BuildContext buildContext, UserAddProvider provider, List<Desk> desks) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(children: [
              Column(children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nom d'utilisateur :",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                const SizedBox(
                  height: 10,
                ),
                StyledTextField(
                    hint: "Non d'utilisateur",
                    labelText: "Non d'utilisateur",
                    error: provider.errors['userName'],
                    controller: provider.controllersMap['userName']!),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Assosier a un bureau :",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                const SizedBox(
                  height: 10,
                ),
                DropdownMenu(
                    onSelected: (value) {
                      logger.d(value);
                      provider.selectedDesk = value ?? '';
                    },
                    dropdownMenuEntries: desks
                        .map((desk) => DropdownMenuEntry(
                            value: desk.id, label: desk.name!))
                        .toList(),
                    hintText: 'Bureau',
                    controller: provider.controllersMap['desk'],
                    errorText: provider.errors['desk'],
                    inputDecorationTheme: InputDecorationTheme(
                        errorStyle: const TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                        ))),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Informations du compte :",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                const SizedBox(
                  height: 10,
                ),
                StyledTextField(
                    hint: 'Numero de téléphone',
                    labelText: 'Numero de téléphone',
                    inputType: TextInputType.number,
                    inputFormaters: [FilteringTextInputFormatter.digitsOnly],
                    controller: provider.controllersMap['phone']!),
                const SizedBox(
                  height: 20,
                ),
                StyledTextField(
                    hint: 'Email',
                    labelText: 'Email',
                    controller: provider.controllersMap['email']!),
                const SizedBox(
                  height: 20,
                ),
                StyledTextField(
                    error: provider.errors["name"],
                    hint: "Nom",
                    labelText: "Nom",
                    controller: provider.controllersMap['name']!),
                const SizedBox(
                  height: 20,
                ),
                StyledTextField(
                    hint: 'Mot de passe',
                    labelText: 'Mot de passe',
                    error: provider.errors['password'],
                    controller: provider.controllersMap['password']!),
                const SizedBox(
                  height: 20,
                ),
                StyledTextField(
                    hint: 'Retapez le Mot de passe',
                    labelText: 'Retapez le Mot de passe',
                    error: provider.errors['retypedPassword'],
                    controller: provider.controllersMap['retypedPassword']!),
                const SizedBox(
                  height: 10,
                ),
              ])
            ]),
          ),
          SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: () {
                    final progress = ProgressHUD.of(buildContext);

                    provider.postUser(
                        onStart: () => progress?.show(),
                        onSuccess: (res) {
                          progress?.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Utilisateur Ajouté avec success')));
                          context.pop(true);
                        },
                        onFail: (e) {
                          logger.e(e);
                          progress?.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            e.toString(),
                            style: const TextStyle(color: Colors.red),
                          )));
                        });
                  },
                  child: const Text('Ajouter')))
        ],
      ),
    );
  }
}
