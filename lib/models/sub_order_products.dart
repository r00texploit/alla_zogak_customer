import './product_option_values.dart';
import './product_options.dart';
import './products.dart';
import './sub_orders.dart';

class SubOrderProducts {
  int id;
  int? subOrderId;
  int? productId;
  int? productOptionId;
  int? productOptionValueId;
  int? qty;
  int? stars;
  int price;
  String? review;
  String? name;
  DateTime createdAt;
  DateTime? updatedAt;
  ProductOptionValues? productOptionValues;
  ProductOptions? productOptions;
  Products? products;
  SubOrders? subOrders;

  SubOrderProducts({
    required this.id,
    required this.subOrderId,
    required this.productId,
    required this.productOptionId,
    required this.productOptionValueId,
    required this.qty,
    required this.stars,
    required this.review,
    required this.createdAt,
    required this.updatedAt,
    this.productOptionValues,
    this.productOptions,
    this.products,
    this.subOrders,
    required this.name,
    required this.price,
  });
  factory SubOrderProducts.fromJson(Map<String, dynamic> json) =>
      SubOrderProducts(
        id: json['id'],
        subOrderId: json['sub_order_id'],
        productId: json['product_id'],
        productOptionId: json['product_option_id'],
        productOptionValueId: json['product_option_value_id'],
        qty: json['qty'],
        stars: json['stars'],
        review: json['review'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] != null? DateTime.parse(json['updatedAt']) : DateTime.now(),
        productOptionValues: json['product_option_values'] != null? ProductOptionValues.fromJson(json['product_option_values']) : null,
        productOptions: json['product_options'] != null? ProductOptions.fromJson(json['product_options']): null,
        products: json['products'] != null? Products.fromJson(json['products']): null,
        subOrders: json['sub_orders'], 
        name: json['name'] ?? '', 
        price: json['price'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['sub_order_id'] = subOrderId;
    map['product_id'] = productId;
    map['product_option_id'] = productOptionId;
    map['product_option_value_id'] = productOptionValueId;
    map['qty'] = qty;
    map['stars'] = stars;
    map['review'] = review;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    map['product_option_values'] = productOptionValues;
    map['product_options'] = productOptions;
    map['products'] = products;
    map['sub_orders'] = subOrders;

    return map;
  }
}
