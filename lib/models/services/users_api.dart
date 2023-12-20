import 'package:dartz/dartz.dart';
import 'package:gestionbureaudechange/models/core/user/user.dart';
import 'package:gestionbureaudechange/models/services/entity_api.dart';
import 'package:logger/logger.dart';

class UsersApi {
  static final logger = Logger();
  static final service = EntityService('users');

  static Future<Either<dynamic, List<dynamic>>> fetshUsers() async {
    return await service.fetshAllObjects();
  }

  static Future<dynamic> getUserById(String id) async {
    return await service.getObjectById(id);
  }

  static Future<Either<dynamic, String>> deleteUser(String id) async {
    return await service.deleteObject(id: id);
  }

  static Future<Either<dynamic, dynamic>> postUser(User userToPost) async {
    return await service.postObject(objectToPost: userToPost.toMap());
  }

  static Future<Either<dynamic, String>> putUser(
      String id, Map<String, dynamic> userToPut) async {
    return await service.putDataToObject(id: id, data: userToPut);
  }
}
