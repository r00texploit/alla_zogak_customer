import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response_model.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://yoo2.smart-node.net/api'));

Future<ResponseModel> addToCart(Map<String, dynamic> data) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.post(
      "/add-to-cart",
      data: data,
      options: Options(
        headers: {"token": sh.getString("token")},
      ),
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.message);
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

Future<ResponseModel> getMyCart() async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.get(
      "/my-cart",
      options: Options(
        headers: {"token": sh.getString("token")},
      ),
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.message);
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

Future<ResponseModel> removeFromCart(int id) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.delete(
      "/remove-from-cart/$id",
      options: Options(
        headers: {"token": sh.getString("token")},
      ),
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.message);
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

Future<ResponseModel> updateCart(int id, Map<String, dynamic> data) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.put(
      "/update-cart/$id",
      data: data,
      options: Options(
        headers: {"token": sh.getString("token")},
      ),
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.message);
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

Future<ResponseModel> order(Map<String, dynamic> data) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.post(
      "/submit-cart",
      data: data,
      options: Options(
        headers: {"token": sh.getString("token")},
      ),
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.message);
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
