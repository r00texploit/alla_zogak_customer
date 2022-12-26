import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response_model.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://yoo2.smart-node.net/api'));

Future<ResponseModel> getMyPreviousOrders(int limit, int offset) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.get(
      "/get-orders?type=previous&offset=$offset&limit=$limit",
      options: Options(
        headers: {"token": sh.getString("token")},
      ),
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      final dt = ResponseModel.fromJson({'status': false});
      dt.setStatus(500);
      return dt;
    }
  }
  final da = ResponseModel(success: false, statusCode: 500);
  da.setStatus(500);
  return da;
}

Future<ResponseModel> getMyCurrentOrders(int limit, int offset) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.get(
      "/get-orders?type=current&offset=$offset&limit=$limit",
      options: Options(
        headers: {"token": sh.getString("token")},
      ),
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      final dt = ResponseModel.fromJson({'status': false});
      dt.setStatus(500);
      return dt;
    }
  }
  final da = ResponseModel(success: false, statusCode: 500);
  da.setStatus(500);
  return da;
}

Future<ResponseModel> getOrderDetails(int id) async {
  try {
    final res = await dio.get(
      "/get-orders?type=current",
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      final dt = ResponseModel.fromJson({'status': false});
      dt.setStatus(500);
      return dt;
    }
  }
  final da = ResponseModel(success: false, statusCode: 500);
  da.setStatus(500);
  return da;
}

Future<ResponseModel> reviewOreder(int id, Map<String, dynamic> data) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.post(
      "/review-orders/$id",
      data: data,
      options: Options(
        headers: {"token": sh.getString("token")},
      ),
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.response);
      }
      final dt = ResponseModel.fromJson({'status': false});
      dt.setStatus(500);
      return dt;
    }
  }
  final da = ResponseModel(success: false, statusCode: 500);
  da.setStatus(500);
  return da;
}
