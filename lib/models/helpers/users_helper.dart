import 'package:dartz/dartz.dart';
import 'package:gestionbureaudechange/models/services/users_api.dart';
import 'package:logger/logger.dart';
import '../core/helper.dart';
import '../core/user/user.dart';

class UsersHelper extends Helper {
  final logger = Logger();

  @override
  Future<Either<dynamic, List<User>>> getAll() async {
    try {
      final res = await UsersApi.fetshUsers();
      return res.fold((l) {
        return Left(l);
      }, (r) {
        final users = r.map((userMap) => User.fromMap(userMap));
        return Right(users.toList());
      });
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<dynamic, User>> getElement(String id) async {
    try {
      final res = await UsersApi.getUserById(id);
      return Right(User.fromMap(res));
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<dynamic, String>> deleteElement(String id) async {
    return UsersApi.deleteUser(id);
  }

  Future<Either<dynamic, String>> putUser(
      String id, Map<String, dynamic> userToPut) {
    return UsersApi.putUser(id, userToPut);
  }

  @override
  Future<Either<dynamic, User>> postElement(dynamic object) async {
    final res = await UsersApi.postUser(object);
    return res.fold((l) {
      return Left(l);
    }, (r) {
      return Right(User.fromMap(r));
    });
  }
}
