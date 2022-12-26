import './cart.dart';
import './product_options.dart';
import './category_options.dart';

class CategoryOptionValues {
  int id;
  int categoryOptionId;
  String value;
  DateTime createdAt;
  DateTime updatedAt;
  List<Cart>? cart;
  List<ProductOptions>? productOptions;
  CategoryOptions? categoryOptions;

  CategoryOptionValues({
    required this.id,
    required this.categoryOptionId,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    this.cart,
    this.productOptions,
    this.categoryOptions,
  });
  factory CategoryOptionValues.fromJson(Map<String, dynamic> json) =>
      CategoryOptionValues(
        id: json['id'],
        categoryOptionId: json['category_option_id'],
        value: json['value'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        cart: json['cart'] != null
            ? List.generate(
                json['cart']!.length, (i) => Cart.fromJson(json['cart']![i]))
            : [],
        productOptions: json['product_options'] != null
            ? List.generate(json['product_options']!.length,
                (i) => ProductOptions.fromJson(json['product_options']![i]))
            : [],
        categoryOptions: json['category_options'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['category_option_id'] = categoryOptionId;
    map['value'] = value;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt.toIso8601String();
    map['cart'] = cart != null
        ? List.generate(cart!.length, (i) => cart![i].toJson())
        : [];
    map['product_options'] = productOptions != null
        ? List.generate(
            productOptions!.length, (i) => productOptions![i].toJson())
        : [];
    map['category_options'] = categoryOptions;

    return map;
  }
}
