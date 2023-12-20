import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/helpers/users_helper.dart';
import 'package:gestionbureaudechange/models/services/desks_api.dart';
import 'package:gestionbureaudechange/models/services/users_api.dart';
import 'package:logger/logger.dart';

import '../models/core/user/desk.dart';
import '../models/core/user/user.dart';

class UserModifyProvider extends ChangeNotifier {
  bool loading = false;
  final logger = Logger();
  Either<dynamic, Map<String, dynamic>> data = const Right({});
  String selectedDesk = '';
  final controllersMap = {
    'name': TextEditingController(),
    'userName': TextEditingController(),
    'desk': TextEditingController(),
    'phone': TextEditingController(),
    'email': TextEditingController(),
  };

  Map<String, String?> errorsMap = {
    'name': null,
    'userName': null,
  };
  bool checkEmptyness(
    String key,
    String toShow,
  ) {
    logger.d('executed with $key');
    var isValid = true;
    if (controllersMap[key]!.text.isEmpty) {
      errorsMap[key] = 'Entrez le $toShow';
      isValid = false;
    } else {
      errorsMap[key] = null;
    }
    return isValid;
  }

  bool validateChanges() {
    bool validName = checkEmptyness('name', 'nom');
    bool validUserName = checkEmptyness('userName', "nom d'utilisateur");
    notifyListeners();
    return validName && validUserName;
  }

  putChanges(String id,
      {required Function onStart,
      required Function(String) onSuccess,
      required Function(dynamic) onFail}) async {
    if (validateChanges()) {
      onStart();
      final userToPut = User.fromMap(controllersMap.map((key, value) =>
          MapEntry(key, value.text.isNotEmpty ? value.text : null)));

      userToPut.desk = selectedDesk;
      final res = await UsersHelper().putUser(id, userToPut.toMap());
      res.fold((l) => onFail(l), (r) => onSuccess(r));
    }
  }

  getData(String id) async {
    try {
      loading = true;
      final user = await UsersApi.getUserById(id);
      final desks = await DesksApi.getAllDesks();
      final list = desks.map((desk) => Desk.fromMap(desk)).toList();

      controllersMap['name']!.text = user['name'];
      controllersMap['userName']!.text = user['userName'];
      selectedDesk = user['desk'];
      controllersMap['phone']!.text = user['phone'] ?? '';
      controllersMap['email']!.text = user['email'] ?? '';

      logger.d('selectedDesk $selectedDesk');

      data = Right({'user': User.fromMap(user), 'desks': list});

      loading = false;
      notifyListeners();
    } catch (e) {
      data = Left(e);
    }
  }
}
