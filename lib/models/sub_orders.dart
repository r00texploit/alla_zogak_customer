import './customers.dart';
import './orders.dart';
import './sub_order_products.dart';
import './vendors.dart';

class SubOrders {
  int id;
  int orderId;
  int vendorId;
  DateTime? readyTime;
  DateTime createdAt;
  DateTime updatedAt;
  Customers? customer;
  Orders? orders;
  List<SubOrderProducts>? subOrderProducts;
  Vendors? vendors;

  SubOrders({
    required this.id,
    required this.orderId,
    required this.vendorId,
    this.readyTime,
    required this.createdAt,
    required this.updatedAt,
    this.orders,
    this.subOrderProducts,
    this.vendors,
    this.customer,
  });
  factory SubOrders.fromJson(Map<String, dynamic> json) => SubOrders(
        id: json['id'],
        orderId: json['order_id'] ?? 0,
        vendorId: json['vendor_id'] ?? 0,
        readyTime: json['ready_time'] != null
            ? DateTime.parse(json['ready_time'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        orders: json['ord'] != null ? Orders.fromJson(json['ord']) : null,
        subOrderProducts: json['sub_order_products'] != null
            ? List.generate(
                json['sub_order_products'].length,
                (i) =>
                    SubOrderProducts.fromJson(json['sub_order_products'][i]))
            : [],
        vendors: json['vendors'] != null? Vendors.fromJson(json['vendors']): null, 
        customer: json['customer'] != null? Customers.fromJson(json['customer']) : null,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['order_id'] = orderId;
    map['vendor_id'] = vendorId;
    map['ready_time'] = readyTime?.toIso8601String();
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt.toIso8601String();
    map['orders'] = orders?.toJson();
    map['sub_order_products'] = subOrderProducts != null
        ? List.generate(
            subOrderProducts!.length, (i) => subOrderProducts![i].toJson())
        : [];
    map['vendors'] = vendors?.toJson();

    return map;
  }
}
