import './customers.dart';
import './sub_orders.dart';

class Orders {
  int id;
  int? customerId;
  String? address;
  String? paymentMethod;
  int? stars;
  String? review;
  DateTime? deliveryTime;
  DateTime createdAt;
  DateTime? updatedAt;
  Customers? customers;
  List<SubOrders>? subOrders;

  Orders({
    required this.id,
    required this.customerId,
    required this.address,
    required this.paymentMethod,
    this.stars,
    this.review,
    this.deliveryTime,
    required this.createdAt,
    this.updatedAt,
    this.customers,
    this.subOrders,
  });
  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        id: json['id'],
        customerId: json['customer_id'],
        address: json['address'],
        paymentMethod: json['payment_method'],
        stars: json['stars'],
        review: json['review'],
        deliveryTime: json['delivery_time'] != null
            ? DateTime.parse(json['delivery_time'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        customers: json['customers'],
        subOrders: json['sub_orders'] != null
            ? List.generate(json['sub_orders']!.length,
                (i) => SubOrders.fromJson(json['sub_orders']![i]))
            : [],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['customer_id'] = customerId;
    map['address'] = address;
    map['payment_method'] = paymentMethod;
    map['stars'] = stars;
    map['review'] = review;
    map['delivery_time'] = deliveryTime?.toIso8601String();
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    map['customers'] = customers;
    map['sub_orders'] = subOrders != null
        ? List.generate(subOrders!.length, (i) => subOrders![i].toJson())
        : [];

    return map;
  }
}
