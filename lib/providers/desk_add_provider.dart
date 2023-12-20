import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/core/currencies.dart';
import 'package:gestionbureaudechange/models/core/user/desk.dart';
import 'package:gestionbureaudechange/models/helpers/desks_helper.dart';
import 'package:logger/logger.dart';
import '../models/core/desk_entry.dart';
import '../models/core/user/new_stock.dart';

class DeskAddProvider extends ChangeNotifier {
  final helper = DesksHelper();
  final logger = Logger();
  final bureauNameController = TextEditingController();
  final montantController = TextEditingController();
  final tauxController = TextEditingController();
  final currencyController = TextEditingController();
  String? montantError;
  String? currencyError;
  String? bureauNameError;
  String? tauxError;

  final focusNodes = {
    'amount': FocusNode(),
    'taux': FocusNode(),
  };

  final List<String> _choicesList = Currencies.get();
  List<String> get choicesList => _choicesList;
  final List<BureauEntry> _entredList = [];
  List<BureauEntry> get entredList => _entredList;

  initNodeFocus() {
    focusNodes.forEach((key, value) {
      value.addListener(() => notifyListeners());
    });
  }

  bool hasFocus() {
    return focusNodes['taux']!.hasFocus || focusNodes['amount']!.hasFocus;
  }

  showBureauNameError() {
    bureauNameError = 'Entrez un nom';
    notifyListeners();
  }

  showMontantError() {
    montantError = 'Entrez un montant';
    notifyListeners();
  }

  showCurrencyError() {
    currencyError = 'Choisissez une device';
    notifyListeners();
  }

  showMadError() {
    tauxError = 'Entrez le taux de conversion';
    notifyListeners();
  }

  hideMontantError() {
    montantError = null;
    notifyListeners();
  }

  hideCurrencyError() {
    currencyError = null;
    notifyListeners();
  }

  hideBureaNameError() {
    bureauNameError = null;
    notifyListeners();
  }

  hideMadError() {
    tauxError = null;
    notifyListeners();
  }

  addEntry() {
    final mad = (double.parse(montantController.text) *
            double.parse(tauxController.text))
        .toString();
    BureauEntry entry =
        BureauEntry(montantController.text, currencyController.text, mad);
    _entredList.add(entry);
    choicesList.remove(entry.currency);
    montantController.clear();
    currencyController.clear();
    tauxController.clear();
    notifyListeners();
  }

  removeEntry(BureauEntry entry) {
    _entredList.remove(entry);
    choicesList.add(entry.currency);
    notifyListeners();
  }

  bool shouldHideMontantError() {
    return montantError != null;
  }

  bool shouldHideCurrencyError() {
    return currencyError != null;
  }

  bool shouldHideNameError() {
    return bureauNameError != null;
  }

  bool shouldHideMadError() {
    return bureauNameError != null;
  }

  bool handleShowingError() {
    if (montantController.text.isEmpty) {
      showMontantError();
      return true;
    }
    if (currencyController.text.isEmpty) {
      showCurrencyError();
      return true;
    }
    if (tauxController.text.isEmpty) {
      showMadError();
      return true;
    }
    return false;
  }

  handleHidingErrors() {
    if (shouldHideMontantError()) {
      hideMontantError();
    }
    if (shouldHideCurrencyError()) {
      hideCurrencyError();
    }
    if (shouldHideMadError()) {
      hideMadError();
    }
  }

  Stock getResultStock() {
    return Stock.fromMap({
      for (var element in entredList)
        element.currency: {'amount': element.montant, 'mad': element.mad},
    });
  }

  void postDesk(Desk deskToPost,
      {required Function(Desk) onSuccess,
      required Function(dynamic) onFail}) async {
    final postRes = await helper.postElement(deskToPost);
    postRes.fold((l) => onFail(l), (r) => onSuccess(r));
  }

  @override
  void dispose() {
    super.dispose();
    bureauNameController.dispose();
    montantController.dispose();
    currencyController.dispose();
    tauxController.dispose();
  }
}
