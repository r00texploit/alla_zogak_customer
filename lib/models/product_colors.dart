import './product_option_values.dart';

class ProductColors {
  int id;
  int r;
  int g;
  int b;
  List<ProductOptionValues>? productOptionValues;

  ProductColors({
    required this.id,
    required this.r,
    required this.g,
    required this.b,
    this.productOptionValues,
  });
  factory ProductColors.fromJson(Map<String, dynamic> json) => ProductColors(
        id: json['id'],
        r: json['r'],
        g: json['g'],
        b: json['b'],
        productOptionValues: json['product_option_values'] != null
            ? List.generate(
                json['product_option_values']!.length,
                (i) => ProductOptionValues.fromJson(
                    json['product_option_values']![i]))
            : [],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['r'] = r;
    map['g'] = g;
    map['b'] = b;
    map['product_option_values'] = productOptionValues != null
        ? List.generate(productOptionValues!.length,
            (i) => productOptionValues![i].toJson())
        : [];

    return map;
  }
}
