import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/helpers/users_helper.dart';
import 'package:gestionbureaudechange/views/desks/desk_add.dart';

class PasswordModifyProvider extends ChangeNotifier {
  final passwordController = TextEditingController();
  final retypedPasswordController = TextEditingController();
  String? passwordError;
  String? retypedPasswordError;

  bool validateData() {
    bool isValid = true;
    if (passwordController.text.isEmpty) {
      isValid = false;
      passwordError = 'Entrez un mot de passe';
    } else {
      passwordError = null;
    }
    if (retypedPasswordController.text != passwordController.text) {
      isValid = false;
      retypedPasswordError = 'Mots de passe non identiques';
    } else {
      retypedPasswordError = null;
    }
    notifyListeners();
    return isValid;
  }

  changePassword(String id,
      {required Function() onStart,
      required Function(String) onSuccess,
      required Function(dynamic) onFail}) async {
    if (validateData()) {
      onStart();
      final newPassword = passwordController.text;
      final data = {"password": newPassword};
      logger.d(data);
      final res = await UsersHelper().putUser(id, data);
      res.fold((l) => onFail(l), (r) => onSuccess(r));
    }
  }
}
