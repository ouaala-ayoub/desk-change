import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/main.dart';
import 'package:gestionbureaudechange/models/helpers/desks_helper.dart';

import '../models/core/currencies.dart';
import '../models/core/desk_entry.dart';
import '../models/core/user/desk.dart';
import '../models/core/user/new_stock.dart';

class DeskModifyProvider extends ChangeNotifier {
  Either<dynamic, Desk> desk = Right(Desk());
  bool loading = false;
  bool initialisedList = false;
  final helper = DesksHelper();
  final Map<String, dynamic> buttonState = {
    'text': 'Enregistrer les modifications',
    'color': Colors.blue
  };
  final controllers = {
    'name': TextEditingController(),
    'amount': TextEditingController(),
    'device': TextEditingController(),
    'taux': TextEditingController(),
  };
  final focusNodes = {
    'amount': FocusNode(),
    'taux': FocusNode(),
  };
  final Map<String, String?> errors = {
    'name': null,
    'amount': null,
    'device': null,
    'taux': null
  };

  final List<String> _choicesList = Currencies.get();
  List<String> get choicesList => _choicesList;
  List<BureauEntry> _entredList = [];
  List<BureauEntry> get entredList => _entredList;

  bool hasFocus() {
    return focusNodes['taux']!.hasFocus || focusNodes['amount']!.hasFocus;
  }

  setDeskName(String name) {
    if (initialisedList) return;
    controllers['name']?.text = name;
  }

  setInitialStock() {
    if (initialisedList) return;
    focusNodes.forEach((key, value) {
      value.addListener(() => notifyListeners());
    });
    desk.fold((l) => logger.e(l), (r) {
      final map = r.stock
          ?.toMap()
          .entries
          .where((entry) => entry.value.toString() != '0')
          .map((entry) {
        // choicesList.remove(entry.key);

        return BureauEntry(
            entry.value['amount'], entry.key, entry.value['mad']);
      }).toList();
      _entredList = map ?? [];
      initialisedList = true;
    });
  }

  getDesk(String id) async {
    loading = true;
    final res = await helper.getDeskById(id);
    desk = res;
    loading = false;
    notifyListeners();
  }

  bool isValidEntry(String target, String frenshName) {
    if (controllers[target]?.text.isEmpty == true) {
      errors[target] = 'entrez un $frenshName';
      notifyListeners();
      return false;
    } else {
      errors[target] = null;
      notifyListeners();
      return true;
    }
  }

  addEntry() {
    final validAmout = isValidEntry('amount', 'montant');
    final validCurrency = isValidEntry('device', 'device');
    final validTaux = isValidEntry('taux', 'Nombre');
    final validaData = validCurrency && validAmout && validTaux;
    if (validaData) {
      final mad = (double.parse(controllers['amount']!.text) *
              double.parse(controllers['taux']!.text))
          .toString();
      final BureauEntry entry = BureauEntry(
          controllers['amount']!.text, controllers['device']!.text, mad);
      logger.d(entry);
      final index = _entredList
          .indexWhere((element) => element.currency == entry.currency);
      if (index != -1) {
        _entredList[index] = entry;
        // _entredList.removeAt(index);
        // _entredList.add(entry);
      }

      // choicesList.remove(entry.currency);
      controllers['amount']?.clear();
      controllers['device']?.clear();
      controllers['taux']?.clear();
      notifyListeners();
    }
  }

  removeEntry(BureauEntry entry) {
    _entredList.remove(entry);
    choicesList.add(entry.currency);
    notifyListeners();
  }

  Stock getResultStock() {
    return Stock.fromMap({
      for (var element in entredList)
        element.currency: {'amount': element.montant, 'mad': element.mad},
    });
  }

  void putDesk(String id, Desk deskToPost,
      {required Function onStart,
      required Function(String) onSuccess,
      required Function(dynamic) onFail}) async {
    logger.d(deskToPost);
    final postRes = await helper.putElement(id, deskToPost);
    postRes.fold((l) => onFail(l), (r) => onSuccess(r));
  }

  disposeControllers() {
    controllers.forEach((key, value) {
      value.dispose();
    });
  }

  disposeFocusNodes() {
    focusNodes.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
    disposeFocusNodes();
  }

  notify() {
    notifyListeners();
  }
}
