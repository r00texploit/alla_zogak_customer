import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/response_model.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://yoo2.smart-node.net/api'));

Future<ResponseModel> registerCustomer(Map<String, dynamic> data) async {
  try {
    final res = await dio.post(
      "/customers",
      data: data,
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      return ResponseModel.fromJson(e.response);
    }
  }
  final da = ResponseModel(success: false, statusCode: 500);
  da.setStatus(500);
  return da;
}

Future<ResponseModel> login(Map<String, dynamic> data) async {
  try {
    final res = await dio.post(
      "/customers/login",
      data: data,
    );
    return ResponseModel.fromJson(res.data);
  } catch (e) {
    if (e is DioError) {
      if (kDebugMode) {
        print(e.response?.data);
        print(e.message);
      }
      return ResponseModel.fromJson({"status": false});
    }
  }
  final da = ResponseModel(success: false, statusCode: 500);
  da.setStatus(500);
  return da;
}

Future<ResponseModel> getProfile() async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.get(
      "/customers/get-profile",
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

Future<ResponseModel> updateProfile(Map<String, dynamic> data) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.post(
      "/customers/update-profile-info",
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

Future<ResponseModel> updateImage(Map<String, dynamic> data) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.post(
      "/customers/update-profile-image",
      data: FormData.fromMap(data),
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

Future<ResponseModel> updatePassword(Map<String, dynamic> data) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.post(
      "/customers/update-password",
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

Future<ResponseModel> sendOtp() async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.get(
      "/customers/get-otp",
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

Future<ResponseModel> verifyOtp(String otp) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.put(
      "/customers/verify-otp/$otp",
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

Future<ResponseModel> verifyRegistrationOtp(
    String otp, Map<String, dynamic> data) async {
  try {
    final res = await dio.post(
      "/customers/verify/$otp",
      data: data,
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

Future<ResponseModel> updatePhone(String otp, Map<String, dynamic> data) async {
  try {
    final sh = await SharedPreferences.getInstance();
    final res = await dio.post(
      "/customers/update-phone/$otp",
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
