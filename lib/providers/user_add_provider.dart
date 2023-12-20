import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/core/user/desk.dart';
import 'package:gestionbureaudechange/models/helpers/desks_helper.dart';
import 'package:gestionbureaudechange/models/helpers/users_helper.dart';
import 'package:gestionbureaudechange/views/desks/desk_add.dart';
import '../models/core/user/user.dart';

class UserAddProvider extends ChangeNotifier {
  bool loading = false;
  Either<dynamic, List<Desk>> desks = const Right([]);
  final usersHelper = UsersHelper();
  final desksHelper = DesksHelper();
  final controllersMap = {
    "userName": TextEditingController(),
    "desk": TextEditingController(),
    "phone": TextEditingController(),
    "email": TextEditingController(),
    "name": TextEditingController(),
    "password": TextEditingController(),
    "retypedPassword": TextEditingController(),
  };
  String selectedDesk = '';
  final Map<String, String?> errors = {
    "userName": null,
    "desk": null,
    "name": null,
    "password": null,
    "retypedPassword": null,
  };
  bool isEmptyField(
    String key,
    String toShow,
  ) {
    logger.d('executed with $key');
    var isValid = true;
    if (controllersMap[key]!.text.isEmpty) {
      errors[key] = 'Entrez le $toShow';
      isValid = false;
    } else {
      errors[key] = null;
    }
    return isValid;
  }

  bool arePasswordsIdentical() {
    var isValid = true;
    if (controllersMap['password']!.text !=
        controllersMap['retypedPassword']!.text) {
      errors['retypedPassword'] = 'Mot de passe non identiques';
      isValid = false;
    } else {
      errors['retypedPassword'] = null;
    }
    return isValid;
  }

  bool isDeskSelected() {
    var isValid = true;
    if (selectedDesk.isEmpty) {
      errors['desk'] = 'selectionnez un bureau';
      isValid = false;
    } else {
      errors['desk'] = null;
    }
    return isValid;
  }

  validateData() {
    final emptyDesk = isDeskSelected();
    final emptyName = isEmptyField('name', 'nom');
    final emptyUserName = isEmptyField('userName', "nom d'utilisateur");
    final emptyPassword = isEmptyField('password', "mot de passe");
    final identicalPasswords = arePasswordsIdentical();
    bool isValidData = emptyDesk &&
        emptyName &&
        emptyUserName &&
        emptyPassword &&
        identicalPasswords;
    logger.d(isValidData);
    notifyListeners(); // Notify listeners of state change
    return isValidData;
  }

  void postUser(
      {required Function onStart,
      required Function(User) onSuccess,
      required Function(dynamic) onFail}) async {
    if (validateData()) {
      onStart();
      final userToPost = User.fromMap(controllersMap.map((key, value) =>
          MapEntry(key, value.text.isNotEmpty ? value.text : null)));
      userToPost.desk = selectedDesk;
      final res = await usersHelper.postElement(userToPost);
      res.fold((l) => onFail(l), (r) => onSuccess(r));
    }
  }

  void getDesks() async {
    loading = true;
    desks = await desksHelper.getAll();
    notifyListeners();
    loading = false;
  }
}
