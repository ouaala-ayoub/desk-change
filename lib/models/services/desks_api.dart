import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:gestionbureaudechange/models/services/entity_api.dart';
import '../core/user/desk.dart';

class DesksApi {
  static final service = EntityService('desks');
  static Future<Either<dynamic, List<dynamic>>> fetshDesks() async {
    return await service.fetshAllObjects();
  }

  static Future<List<dynamic>> getAllDesks() async {
    return await service.fetshAllNoErrorHandling();
  }

  static Future<dynamic> getDeskById(String id) async {
    return await service.getObjectById(id);
  }

  static Future<List<dynamic>> getDeskTransactions(String id) async {
    final endpoint =
        'https://desk-change.vercel.app/api/desks/$id/transactions';
    final res = await Dio().get(endpoint);
    return res.data;
  }

  static Future<Either<dynamic, String>> deleteDesk(String id) async {
    return await service.deleteObject(id: id);
  }

  static Future<Either<dynamic, dynamic>> postDesk(Desk deskToPost) async {
    return await service.postObject(objectToPost: deskToPost.toMap());
  }

  static Future<Either<dynamic, dynamic>> putDesk(
      String id, Desk deskToPost) async {
    return await service.putDataToObject(id: id, data: deskToPost.toMap());
  }
}
