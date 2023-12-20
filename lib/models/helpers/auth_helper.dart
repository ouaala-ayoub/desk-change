import 'package:dartz/dartz.dart';
import '../core/admin.dart';
import '../core/user_creds.dart';
import '../services/auth_api.dart';

//! i can just return the admin from the service auth api class
class AuthHelper {
  static Future<Either<dynamic, Admin>> getAuth() async {
    var res = await AuthApi.getAuth();
    return res.fold((l) => Left(l), (r) {
      var admin = Admin.fromMap(r);
      return Right(admin);
    });
  }

  static Future<Either<dynamic, Admin>> login(UserCredentiels userCreds) async {
    var res = await AuthApi.login(userCreds);
    return res.fold((l) => Left(l), (r) => Right(Admin.fromMap(r)));
  }
}
