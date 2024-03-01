import 'package:dartz/dartz.dart';
import 'package:gestionbureaudechange/main.dart';
import 'package:gestionbureaudechange/models/core/user/desk.dart';
import 'package:gestionbureaudechange/models/services/desks_api.dart';
import '../core/helper.dart';
import '../core/transaction.dart';

class DesksHelper extends Helper {
  @override
  Future<Either<dynamic, List<Desk>>> getAll() async {
    try {
      final res = await DesksApi.fetshDesks();
      return res.fold((l) {
        return Left(l);
      }, (r) {
        final desks = r.map((deskMap) => Desk.fromMap(deskMap));
        return Right(desks.toList());
      });
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<dynamic, String>> deleteElement(String id) async {
    return DesksApi.deleteDesk(id);
  }

  @override
  Future<Either<dynamic, DeskAndTransactions>> getElement(String id) async {
    try {
      final results = await Future.wait(
          [DesksApi.getDeskById(id), DesksApi.getDeskTransactions(id)]);
      final desk = results[0];
      final transactions = results[1];
      return Right(
        DeskAndTransactions(
          Desk.fromMap(desk),
          transactions.map((map) => Transaction.fromMap(map)).toList(),
        ),
      );
    } catch (e) {
      logger.e(e.toString());
      return Left(e);
    }
  }

  Future<Either<dynamic, Desk>> getDeskById(String id) async {
    try {
      final desk = await DesksApi.getDeskById(id);
      return Right(Desk.fromMap(desk));
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<dynamic, Desk>> postElement(dynamic object) async {
    final res = await DesksApi.postDesk(object);
    return res.fold((l) {
      return Left(l);
    }, (r) {
      return Right(Desk.fromMap(r));
    });
  }

  @override
  Future<Either<dynamic, String>> putElement(String id, dynamic object) async {
    final res = await DesksApi.putDesk(id, object);
    return res.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }
}

class DeskAndTransactions {
  Desk desk;
  List<Transaction> transactions;

  DeskAndTransactions(this.desk, this.transactions);
}
