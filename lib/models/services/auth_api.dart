import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestionbureaudechange/models/core/user_creds.dart';
import 'package:gestionbureaudechange/views/desks/desk_add.dart';
import 'package:logger/logger.dart';

class AuthApi {
  static const storage = FlutterSecureStorage();

  static logout() async {
    await storage.delete(key: 'session_cookie');
  }

  static Future<Either<dynamic, dynamic>> getAuth() async {
    try {
      // return Left({"resMessage": "message"});
      const endpoint = 'https://desk-change.vercel.app/api/admins/auth';

      String? value = await storage.read(key: 'session_cookie');
      Logger().d('cookie stored $value');

      final options =
          BaseOptions(headers: {'Cookie': 'admin-session=${value.toString()}'});
      logger.i("passed options ${options.headers}");
      var response = await Dio(options).post(endpoint);
      logger.i("passed send req");
      Logger().d('response ${response.data}');
      return Right(response.data);
    } on DioException catch (e) {
      logger.e("catched dio exception");
      final message = e.response?.data['message'];
      return message != null
          ? Left({"resMessage": message})
          : Left({"dioMessage": e.message});
    } catch (e) {
      logger.e("catched dio exception");
      return Left({"resMessage": e.toString()});
    }
  }

  static Future<Either<dynamic, dynamic>> login(
      UserCredentiels userCreds) async {
    try {
      const endpoint = 'https://desk-change.vercel.app/api/admins/sign';
      final reqOptions = Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      });
      logger.i('user ${userCreds.toJson()}');
      final response = await Dio()
          .post(endpoint, options: reqOptions, data: userCreds.toJson());

      final cookies = response.headers["set-cookie"];
      //extract the cookie from the header
      if (cookies != null && cookies.isNotEmpty) {
        final sessionCookie = cookies
            .firstWhere((cookie) => cookie.startsWith('admin-session='),
                orElse: () => throw Exception('session cookie found'))
            .substring(14)
            .split(';')[0];

        if (sessionCookie.isNotEmpty) {
          Logger().d(sessionCookie);
          storage.write(key: 'session_cookie', value: sessionCookie);
        } else {
          throw Exception('Problem with the session cookie');
        }
      } else {
        throw Exception('no cookie found');
      }
      return Right(response.data);
    } catch (e) {
      if (e is DioException) {
        //handle DioError here by error type or by error code
        logger.e('dio exception ${e.response?.data}');
        if (e.response?.data != null) {
          return Left(e.response!.data['message']);
        }
      } else {}
      Logger().e(e.toString());
      return Left(e);
    }
  }
}
