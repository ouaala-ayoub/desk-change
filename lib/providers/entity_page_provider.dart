import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../models/core/helper.dart';

class EntityPageProvider<T> extends ChangeNotifier {
  EntityPageProvider(this.helper);

  final Helper helper;
  bool loding = false;
  Either<dynamic, T>? data;

  getData(String id) async {
    loding = true;
    // notifyListeners();
    data = await helper.getElement(id);
    loding = false;
    notifyListeners();
  }
}
