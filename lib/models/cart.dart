import './category_option_values.dart';
import './customers.dart';
import './product_option_values.dart';
import './products.dart';

class Cart {
  int id;
  int coustmerId;
  int productId;
  int? categoryOptionValueId;
  int productOptionValueId;
  int qty;
  CategoryOptionValues? categoryOptionValues;
  Customers? customers;
  ProductOptionValues? productOptionValues;
  Products? products;

  Cart({
    required this.id,
    required this.coustmerId,
    required this.productId,
    this.categoryOptionValueId,
    required this.productOptionValueId,
    required this.qty,
    this.categoryOptionValues,
    this.customers,
    this.productOptionValues,
    this.products,
  });
  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json['id'],
        coustmerId: json['coustmer_id'],
        productId: json['product_id'],
        categoryOptionValueId: json['category_option_value_id'],
        productOptionValueId: json['product_option_value_id'],
        qty: json['qty'],
        categoryOptionValues: json['category_option_values'],
        customers: json['customers'],
        productOptionValues: json['product_option_values'] != null? ProductOptionValues.fromJson(json['product_option_values']) : null,
        products: json['products'] != null?Products.fromJson(json['products']) : null,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['coustmer_id'] = coustmerId;
    map['product_id'] = productId;
    map['category_option_value_id'] = categoryOptionValueId;
    map['product_option_value_id'] = productOptionValueId;
    map['qty'] = qty;
    map['category_option_values'] = categoryOptionValues;
    map['customers'] = customers;
    map['product_option_values'] = productOptionValues;
    map['products'] = products;

    return map;
  }
}
