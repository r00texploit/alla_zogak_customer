import './category_options.dart';
import './product_option_values.dart';
import './sub_order_products.dart';
import './products.dart';

class ProductOptions {
  int id;
  int productId;
  int categoryOptionId;
  DateTime createdAt;
  DateTime updatedAt;
  CategoryOptions? categoryOption;
  List<ProductOptionValues>? productOptionValues;
  List<SubOrderProducts>? subOrderProducts;
  Products? products;

  ProductOptions({
    required this.id,
    required this.productId,
    required this.categoryOptionId,
    required this.createdAt,
    required this.updatedAt,
    this.categoryOption,
    this.productOptionValues,
    this.subOrderProducts,
    this.products,
  });
  factory ProductOptions.fromJson(Map<String, dynamic> json) => ProductOptions(
        id: json['id'],
        productId: json['product_id'],
        categoryOptionId: json['category_option_id'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        categoryOption: json['category_option'] != null? CategoryOptions.fromJson(json['category_option']): null,
        productOptionValues: json['product_option_values'] != null
            ? List.generate(
                json['product_option_values']!.length,
                (i) => ProductOptionValues.fromJson(
                    json['product_option_values']![i]))
            : [],
        subOrderProducts: json['sub_order_products'] != null
            ? List.generate(
                json['sub_order_products']!.length,
                (i) =>
                    SubOrderProducts.fromJson(json['sub_order_products']![i]))
            : [],
        products: json['products'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['product_id'] = productId;
    map['category_option_values_id'] = categoryOptionId;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt.toIso8601String();
    map['category_option_values'] = categoryOption?.toJson();
    map['product_option_values'] = productOptionValues != null
        ? List.generate(productOptionValues!.length,
            (i) => productOptionValues![i].toJson())
        : [];
    map['sub_order_products'] = subOrderProducts != null
        ? List.generate(
            subOrderProducts!.length, (i) => subOrderProducts![i].toJson())
        : [];
    map['products'] = products;

    return map;
  }
}
