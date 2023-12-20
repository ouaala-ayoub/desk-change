import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gestionbureaudechange/models/core/user/desk.dart';
import 'package:gestionbureaudechange/models/core/user/user.dart';
import 'package:gestionbureaudechange/providers/user_modify_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../helper_widgets/styled_text_field.dart';

class UserModify extends StatefulWidget {
  final String id;
  const UserModify({required this.id, super.key});

  @override
  State<UserModify> createState() => _UserModifyState();
}

class _UserModifyState extends State<UserModify> {
  final logger = Logger();
  @override
  void initState() {
    super.initState();
    Logger().d(widget.id);
    context.read<UserModifyProvider>().getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modification des informations')),
      body: ProgressHUD(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<UserModifyProvider>(
            builder: (context, provider, child) {
              return provider.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : provider.data.fold(
                      (l) => Center(
                            child: Text(l.toString()),
                          ),
                      (data) => Column(children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Associer a un nouveau bureau :",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      DropdownMenu(
                                          initialSelection:
                                              getInitialItemFromDesks(data),
                                          onSelected: (value) {
                                            provider.selectedDesk = value ?? '';
                                            logger.d(
                                                'selected desk ${provider.selectedDesk}');
                                          },
                                          dropdownMenuEntries: (data['desks']
                                                  as List<Desk>)
                                              .map((desk) => DropdownMenuEntry(
                                                  value: desk.id as String,
                                                  label: desk.name!))
                                              .toList(),
                                          hintText: 'Bureau',
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                                  errorStyle: const TextStyle(
                                                      color: Colors.red),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                  ))),
                                      const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Modifier les informations : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      StyledTextField(
                                          labelText: 'Nom',
                                          hint: 'Nom',
                                          error: provider.errorsMap['name'],
                                          controller:
                                              provider.controllersMap['name']!),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      StyledTextField(
                                          hint: "Nom d'utilisateur",
                                          labelText: "Nom d'utilisateur",
                                          error: provider.errorsMap['userName'],
                                          controller: provider
                                              .controllersMap['userName']!),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      StyledTextField(
                                          hint: "Numero du téléphone",
                                          labelText: "Numero du téléphone",
                                          controller: provider
                                              .controllersMap['phone']!),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      StyledTextField(
                                          hint: "Email",
                                          labelText: "Email",
                                          controller: provider
                                              .controllersMap['email']!),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                    onPressed: () {
                                      final progress = ProgressHUD.of(context);
                                      provider.putChanges(widget.id,
                                          onStart: () => progress?.show(),
                                          onFail: (e) {
                                            logger.e(e);
                                            progress?.dismiss();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                              e.toString(),
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            )));
                                          },
                                          onSuccess: (res) {
                                            logger.i(res);
                                            progress?.dismiss();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                              res,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )));
                                          });
                                    },
                                    child: const Text(
                                        'Enregister les mofications')))
                          ]));
            },
          ),
        ),
      ),
    );
  }

  String? getInitialItemFromDesks(Map<String, dynamic> data) {
    //todo fix this bug where there is no desk registered
    User user = data['user'];
    try {
      Desk? found = data['desks'].firstWhere(
        (desk) => desk.id! == user.desk,
      );
      logger.d('found ${found?.name!}');
      return found?.id!;
    } catch (e) {
      return null;
    }
  }
}
