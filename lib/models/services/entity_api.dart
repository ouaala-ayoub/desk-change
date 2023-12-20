import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class EntityService {
  final logger = Logger();
  String type;
  EntityService(this.type);

  Future<List<dynamic>> fetshAllNoErrorHandling() async {
    final endpoint = 'https://desk-change.vercel.app/api/$type';
    final res = await Dio().get(endpoint);
    return res.data;
  }

  Future<Either<dynamic, List<dynamic>>> fetshAllObjects() async {
    try {
      final endpoint = 'https://desk-change.vercel.app/api/$type';
      final res = await Dio().get(endpoint);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<dynamic> getObjectById(String id) async {
    final endpoint = 'https://desk-change.vercel.app/api/$type/$id';
    final res = await Dio().get(endpoint);
    return res.data;
  }

  Future<Either<dynamic, String>> deleteObject({required String id}) async {
    try {
      final endpoint = 'https://desk-change.vercel.app/api/$type/$id';
      final res = await Dio().delete(endpoint);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, String>> putDataToObject(
      {required String id, required Map<String, dynamic> data}) async {
    try {
      final endpoint = 'https://desk-change.vercel.app/api/$type/$id';
      final reqOptions = Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      });
      final jsonObject = json.encode(data);
      final res =
          await Dio().put(endpoint, options: reqOptions, data: jsonObject);
      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<dynamic, dynamic>> postObject(
      {required Map<String, dynamic> objectToPost}) async {
    try {
      final endpoint = 'https://desk-change.vercel.app/api/$type';
      final reqOptions = Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      });
      final jsonObject = json.encode(objectToPost);
      final res =
          await Dio().post(endpoint, options: reqOptions, data: jsonObject);

      return Right(res.data);
    } catch (e) {
      return Left(e);
    }
  }
}
