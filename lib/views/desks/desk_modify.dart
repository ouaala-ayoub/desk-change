import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gestionbureaudechange/providers/desk_modify_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../models/core/user/desk.dart';
import '../../models/helpers/functions.dart';
import '../helper_widgets/styled_text_field.dart';

class DeskModify extends StatefulWidget {
  final String id;
  const DeskModify({required this.id, super.key});

  @override
  State<DeskModify> createState() => _DeskModifyState();
}

class _DeskModifyState extends State<DeskModify> {
  @override
  void initState() {
    super.initState();
    context.read<DeskModifyProvider>().getDesk(widget.id);
  }

  //todo fix the snackbar and dialog problem
  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    return Scaffold(
      appBar: AppBar(title: const Text('Modification des informations')),
      body: ProgressHUD(
        child: Consumer<DeskModifyProvider>(
          builder: (consumerContext, provider, child) {
            return provider.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.desk.fold(
                    (l) => Center(
                          child: ErrorWidget(l),
                        ), (r) {
                    provider.setDeskName(r.name!);
                    provider.setInitialStock();
                    logger.i(provider.entredList);
                    return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            StyledTextField(
                                hint: 'Nom du bureau',
                                labelText: 'Nom du bureau',
                                inputType: TextInputType.text,
                                error: provider.errors['name'],
                                controller: provider.controllers['name']!),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Textfield
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      StyledTextField(
                                          focusNode:
                                              provider.focusNodes['amount'],
                                          inputFormaters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          labelText: 'Montant',
                                          error: provider.errors['amount'],
                                          hint: 'Montant',
                                          inputType: const TextInputType
                                              .numberWithOptions(
                                              decimal: false, signed: false),
                                          controller:
                                              provider.controllers['amount']!),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //todo change with taux
                                      StyledTextField(
                                          focusNode:
                                              provider.focusNodes['taux'],
                                          inputFormaters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*'))
                                          ],
                                          labelText: 'Taux',
                                          error: provider.errors['taux'],
                                          hint: 'taux',
                                          inputType: const TextInputType
                                              .numberWithOptions(
                                              decimal: true, signed: false),
                                          controller:
                                              provider.controllers['taux']!),
                                    ],
                                  ),
                                ),

                                // Spacer for some space between the text field and dropdown
                                const SizedBox(width: 10),

                                // Dropdown
                                Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 40,
                                          blurStyle: BlurStyle.normal,
                                          spreadRadius: 10),
                                    ],
                                  ),
                                  child: DropdownMenu(
                                    onSelected: (value) {
                                      final entry = provider.entredList
                                          .firstWhere((entry) =>
                                              entry.currency == value);
                                      provider.controllers['amount']!.text =
                                          entry.montant;
                                      provider.controllers['taux']!.text =
                                          tauxCalcul(entry.mad, entry.montant)
                                              .toString();
                                    },
                                    hintText: 'device',
                                    controller: provider.controllers['device'],
                                    errorText: provider.errors['device'],
                                    inputDecorationTheme: InputDecorationTheme(
                                        errorStyle:
                                            const TextStyle(color: Colors.red),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        // filled: true,
                                        // fillColor: Colors.white,
                                        hintStyle: const TextStyle(
                                          fontSize: 14,
                                        )),
                                    dropdownMenuEntries: provider.choicesList
                                        .map((currency) => DropdownMenuEntry(
                                            value: currency, label: currency))
                                        .toList(),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    provider.addEntry();
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: provider.entredList.length,
                                  itemBuilder: (context, index) {
                                    final current = provider.entredList[index];
                                    // logger.d('current $current');
                                    return Container(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  '${formatNumberWithCommas(double.parse(current.montant))} ${current.currency} = ${formatNumberWithCommas(double.parse(current.mad))} MAD')),
                                          GestureDetector(
                                              onTap: () {
                                                provider.removeEntry(current);
                                              },
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                                size: 30,
                                              ))
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                    style: FilledButton.styleFrom(
                                        backgroundColor: provider.hasFocus()
                                            ? Colors.green
                                            : const Color(0xFF08648c)),
                                    onPressed: () {
                                      //behaviour of add stock
                                      if (provider.hasFocus()) {
                                        provider.addEntry();
                                      } else {
                                        //behviour of update changes
                                        if (!provider.isValidEntry(
                                            'name', 'Nom')) {
                                          return;
                                        }

                                        final desk = Desk(
                                            name: provider
                                                .controllers['name']!.text,
                                            stock: provider.getResultStock());

                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      'Etes vous sure des changements ?'),
                                                  actions: [
                                                    FilledButton(
                                                        onPressed: () {
                                                          putChanges(
                                                              provider,
                                                              desk,
                                                              logger,
                                                              consumerContext,
                                                              context);
                                                          context.pop();
                                                        },
                                                        child:
                                                            const Text('Oui')),
                                                    FilledButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        child:
                                                            const Text('Non'))
                                                  ],
                                                ));
                                      }
                                    },
                                    child: Text(provider.hasFocus()
                                        ? 'Ajouter le stock'
                                        : 'Enregistrer les modifications')))
                          ],
                        ));
                  });
          },
        ),
      ),
    );
  }

  void putChanges(DeskModifyProvider provider, Desk desk, Logger logger,
      BuildContext consumerContext, BuildContext context) {
    return provider.putDesk(widget.id, desk,
        onStart: () => null,
        onSuccess: (res) {
          logger.d(res);
          ScaffoldMessenger.of(consumerContext).showSnackBar(const SnackBar(
              content: Text('Informations modifiée avec success')));
        },
        onFail: (e) {
          logger.e(e);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            'Erreur innatendue',
            style: TextStyle(color: Colors.red),
          )));
        });
  }
}
