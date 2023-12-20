import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/core/helper.dart';

class FilterableListProvider<T> extends ChangeNotifier {
  FilterableListProvider(this.helper);

  final Helper helper;
  final logger = Logger();
  bool loading = false;
  Either<dynamic, List<T>> list = const Right([]);
  Either<dynamic, List<T>> _found = const Right([]);
  Either<dynamic, List<T>> get found => _found;

  deleteElement(String id,
      {required Function() onFail, Function()? onSuccess}) async {
    loading = true;
    final deleted = await helper.deleteElement(id);
    deleted.fold((l) {
      onFail();
    }, (r) {
      getList();
      onSuccess?.call();
    });
    loading = false;
    notifyListeners();
  }

  getList() async {
    loading = true;
    list = await helper.getAll();
    _found = list;
    loading = false;
    notifyListeners();
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      _found = list;
    } else {
      _found = list.fold((l) => Left(l), (r) {
        return Right(r
            .where((element) =>
                element
                    .toString()
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ==
                true)
            .toList());
      });
    }
    notifyListeners();
  }
}
