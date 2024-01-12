import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:gestionbureaudechange/models/core/transaction.dart';
import 'package:gestionbureaudechange/models/helpers/desks_helper.dart';
import '../models/core/helper.dart';

class EntityPageProvider<T> extends ChangeNotifier {
  EntityPageProvider(this.helper);

  final Helper helper;
  bool loading = false;
  Either<dynamic, T>? data;

  getData(String id) async {
    loading = true;
    // notifyListeners();
    data = await helper.getElement(id);
    loading = false;
    notifyListeners();
  }
}

class FilterableEntity<T, F> extends EntityPageProvider {
  FilterableEntity(Helper helper) : super(helper);
  Either<dynamic, List<Transaction>> _filterRes = const Right([]);
  Either<dynamic, List<Transaction>> get filterRes => _filterRes;
  final Map<String, dynamic> filters = {
    'type': null,
    'date': null,
  };
  setFilter(key, value) {
    filters[key] = value;
    filter();
    notifyListeners();
  }

  handleSelection(bool isSelected, key, value) {
    isSelected ? setFilter(key, value) : setFilter(key, null);
  }

  @override
  getData(String id) async {
    loading = true;
    data = await helper.getElement(id);

    _filterRes = initTransactionsState();
    loading = false;
    notifyListeners();
  }

  initTransactionsState() {
    return data!.fold((l) => Left(l), (data) {
      (data as DeskAndTransactions)
          .transactions
          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return Right(data.transactions);
    });
  }

  filter() {
    if (filters['type'] == null && filters['date'] == null) {
      _filterRes = initTransactionsState();
    } else {
      _filterRes = data!.fold((l) => Left(l), (data) {
        final transactions = (data as DeskAndTransactions).transactions;
        final found = transactions.where((element) {
          final typeCondition = element.type == filters['type'];
          final dateCondition = _isSameDay(element.createdAt!, filters['date']);

          if (filters['type'] == null) {
            return dateCondition;
          } else if (filters['date'] == null) {
            return typeCondition;
          }

          return typeCondition && dateCondition;
        }).toList();
        return Right(found);
      });
    }
  }

  bool _isSameDay(DateTime date1, DateTime? date2) {
    return date1.year == date2?.year &&
        date1.month == date2?.month &&
        date1.day == date2?.day;
  }
}
