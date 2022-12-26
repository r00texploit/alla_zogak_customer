import './product_option_values.dart';
import './products.dart';

class ProductImages {
  int id;
  String image;
  bool? isCover;
  int? productId;
  DateTime createdAt;
  DateTime updatedAt;
  List<ProductOptionValues>? productOptionValues;
  Products? products;

  ProductImages({
    required this.id,
    required this.image,
    this.isCover,
    this.productId,
    required this.createdAt,
    required this.updatedAt,
    this.productOptionValues,
    this.products,
  });
  factory ProductImages.fromJson(Map<String, dynamic> json) => ProductImages(
        id: json['id'],
        image: json['image'],
        isCover: json['is_cover'] == 1? true : false,
        productId: json['product_id'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        productOptionValues: json['product_option_values'] != null
            ? List.generate(
                json['product_option_values']!.length,
                (i) => ProductOptionValues.fromJson(
                    json['product_option_values']![i]))
            : [],
        products: json['products'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['image'] = image;
    map['is_cover'] = isCover;
    map['product_id'] = productId;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt.toIso8601String();
    map['product_option_values'] = productOptionValues != null
        ? List.generate(productOptionValues!.length,
            (i) => productOptionValues![i].toJson())
        : [];
    map['products'] = products;

    return map;
  }
}
