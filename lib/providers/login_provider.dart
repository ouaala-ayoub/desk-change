import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/core/user_creds.dart';
import 'package:gestionbureaudechange/models/helpers/auth_helper.dart';

class LoginProvider extends ChangeNotifier {
  bool loading = false;
  String errorMessage = '';
  Either<dynamic, dynamic>? loginRes;
  final TextEditingController userNameController =
      TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");

  login(UserCredentiels userCreds,
      {required Function(dynamic) onLoginSuccess,
      required Function(dynamic) onLoginFail}) async {
    loading = true;
    loginRes = await AuthHelper.login(userCreds);
    loginRes?.fold((l) {
      onLoginFail(l);
    }, (r) {
      onLoginSuccess(r);
    });
    loading = false;
    notifyListeners();
  }

  setErrorMessage(String value) {
    errorMessage = value;
    notifyListeners();
  }

  disposeControllers() {
    userNameController.dispose();
    passwordController.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
  }
}
