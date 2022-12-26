import './admins.dart';
import './customers.dart';
import './vendors.dart';

class Sessions {
  int id;
  String token;
  String socketId;
  int? adminId;
  int? customerId;
  int? vendorId;
  String deviceOs;
  String deviceModel;
  DateTime startTime;
  DateTime? finishTime;
  Admins? admins;
  Customers? customers;
  Vendors? vendors;

  Sessions({
    required this.id,
    required this.token,
    required this.socketId,
    this.adminId,
    this.customerId,
    this.vendorId,
    required this.deviceOs,
    required this.deviceModel,
    required this.startTime,
    this.finishTime,
    this.admins,
    this.customers,
    this.vendors,
  });
  factory Sessions.fromJson(Map<String, dynamic> json) => Sessions(
        id: json['id'],
        token: json['token'],
        socketId: json['socket_id'],
        adminId: json['admin_id'],
        customerId: json['customer_id'],
        vendorId: json['vendor_id'],
        deviceOs: json['device_os'],
        deviceModel: json['device_model'],
        startTime: DateTime.parse(json['start_time']),
        finishTime: json['finish_time'] != null
            ? DateTime.parse(json['finish_time'])
            : null,
        admins: json['admins'],
        customers: json['customers'],
        vendors: json['vendors'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['token'] = token;
    map['socket_id'] = socketId;
    map['admin_id'] = adminId;
    map['customer_id'] = customerId;
    map['vendor_id'] = vendorId;
    map['device_os'] = deviceOs;
    map['device_model'] = deviceModel;
    map['start_time'] = startTime.toIso8601String();
    map['finish_time'] = finishTime?.toIso8601String();
    map['admins'] = admins;
    map['customers'] = customers;
    map['vendors'] = vendors;

    return map;
  }
}
