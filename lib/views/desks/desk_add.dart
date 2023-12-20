import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gestionbureaudechange/models/core/user/desk.dart';
import 'package:gestionbureaudechange/models/helpers/functions.dart';
import 'package:gestionbureaudechange/providers/desk_add_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../helper_widgets/styled_text_field.dart';

final logger = Logger();

class DeskAdd extends StatelessWidget {
  const DeskAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ajouter un bureau'),
        ),
        body: const DeskPaletteWidget(),
      ),
    );
  }
}

class DeskPaletteWidget extends StatefulWidget {
  const DeskPaletteWidget({
    super.key,
  });

  @override
  State<DeskPaletteWidget> createState() => _DeskPaletteWidgetState();
}

class _DeskPaletteWidgetState extends State<DeskPaletteWidget> {
  @override
  void initState() {
    super.initState();
    context.read<DeskAddProvider>().initNodeFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<DeskAddProvider>(
            builder: (context, value, child) => StyledTextField(
                error: value.bureauNameError,
                hint: 'Nom du bureau',
                labelText: 'Nom du bureau',
                inputType: TextInputType.text,
                controller: value.bureauNameController),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: const TextSpan(children: [
            TextSpan(
                text: 'Appuyez sur le',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.add,
                  color: Colors.green,
                )),
            TextSpan(
                text: 'pour ajouter le stock',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18))
          ])),
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
                    Consumer<DeskAddProvider>(
                      builder: (context, value, child) => StyledTextField(
                          focusNode: value.focusNodes['amount'],
                          inputFormaters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          labelText: 'Montant',
                          error: value.montantError,
                          hint: 'Montant',
                          inputType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          controller: value.montantController),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //todo change with taux
                    Consumer<DeskAddProvider>(
                      builder: (context, value, child) => StyledTextField(
                          focusNode: value.focusNodes['taux'],
                          inputFormaters: [
                            //to allow only inputs in the format x.x
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'))
                          ],
                          labelText: 'Taux',
                          error: value.tauxError,
                          hint: 'taux',
                          inputType: const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          controller: value.tauxController),
                    )
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
                child: Consumer<DeskAddProvider>(
                  builder: (context, value, child) => DropdownMenu(
                    hintText: 'device',
                    controller: value.currencyController,
                    errorText: value.currencyError,
                    inputDecorationTheme: InputDecorationTheme(
                        errorStyle: const TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // filled: true,
                        // fillColor: Colors.white,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                        )),
                    dropdownMenuEntries: value.choicesList
                        .map((currency) =>
                            DropdownMenuEntry(value: currency, label: currency))
                        .toList(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  final provider = context.read<DeskAddProvider>();
                  if (provider.handleShowingError()) {
                    return;
                  }
                  context.read<DeskAddProvider>().addEntry();
                  provider.handleHidingErrors();
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
              )
            ],
          ),
          Consumer<DeskAddProvider>(
            builder: (context, value, child) {
              return Expanded(
                child: ListView.builder(
                    itemCount: value.entredList.length,
                    itemBuilder: (context, index) {
                      final current = value.entredList[index];
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
                                  value.removeEntry(current);
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
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<DeskAddProvider>(
              builder: (context, value, child) => FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: value.hasFocus()
                          ? Colors.green
                          : const Color(0xFF08648c)),
                  onPressed: () {
                    if (value.hasFocus()) {
                      if (value.handleShowingError()) {
                        return;
                      }
                      context.read<DeskAddProvider>().addEntry();
                      value.handleHidingErrors();
                    } else {
                      if (value.bureauNameController.text.isEmpty) {
                        value.showBureauNameError();
                        return;
                      }
                      final progress = ProgressHUD.of(context);
                      progress?.show();
                      final stock = value.getResultStock();
                      // logger.d(stock.toMap());
                      final deskToPost = Desk(
                          name: value.bureauNameController.text, stock: stock);
                      logger.d(deskToPost.toMap());
                      value.postDesk(
                        deskToPost,
                        onSuccess: (desk) {
                          logger.d(desk);
                          progress?.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Bureau Ajouté avec success')));
                          context.pop(true);
                        },
                        onFail: (e) {
                          logger.e(e);
                          progress?.dismiss();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                            'Erreur innatendue',
                            style: TextStyle(color: Colors.red),
                          )));
                        },
                      );
                    }
                  },
                  child: Text(value.hasFocus()
                      ? 'Ajouter le stock'
                      : 'Ajouter le bureau')),
            ),
          )
        ],
      ),
    );
  }
}
