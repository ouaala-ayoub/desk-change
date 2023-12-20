import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/main.dart';
import 'package:gestionbureaudechange/models/core/admin.dart';
import 'package:gestionbureaudechange/models/helpers/auth_helper.dart';
import 'package:gestionbureaudechange/models/services/auth_api.dart';

class AuthProvider extends ChangeNotifier {
  bool loading = true;
  late Either<dynamic, Admin> auth;

  getUserAuth() async {
    loading = true;
    auth = await AuthHelper.getAuth();
    logger.d('auth $auth');
    loading = false;
    notifyListeners();
  }

  logout(Function() onLogout) async {
    await AuthApi.logout();
    onLogout();
    auth = const Left(null);
    notifyListeners();
  }

  setError(e) {
    Left(e);
  }

  setAdmin(Admin admin) {
    auth = Right(admin);
  }
}
