class ResponseModel {
  bool success;
  bool? otpRequired;
  int? total;
  int statusCode;
  dynamic data;
  String? message;
  ResponseModel({
    required this.success,
    required this.statusCode,
    this.data,
    this.total,
    this.message,
    this.otpRequired,
  });

  factory ResponseModel.fromJson(dynamic json) {
    return ResponseModel(
      success: json['status'],
      statusCode: 200,
      data: json['data'],
      total: json['total'],
      message: json['message'],
      otpRequired: json['otp_required'] == true ? json['otp_required'] : null,
    );
  }

  setStatus(int code) {
    statusCode = code;
  }
}
