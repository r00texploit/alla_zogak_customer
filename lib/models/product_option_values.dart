import '../models/category_option_values.dart';

import './product_colors.dart';
import './product_images.dart';
import './cart.dart';
import './sub_order_products.dart';
import './product_options.dart';

class ProductOptionValues {
  int id;
  int productOptionId;
  int? productColorId;
  int productImageId;
  int? value;
  int? qty;
  DateTime createdAt;
  DateTime updatedAt;
  ProductColors? productColors;
  ProductImages? productImages;
  CategoryOptionValues? categoryOpitionValues;
  List<Cart>? cart;
  List<SubOrderProducts>? subOrderProducts;
  ProductOptions? productOptions;

  ProductOptionValues({
    required this.id,
    required this.productOptionId,
    this.productColorId,
    required this.productImageId,
    this.value,
    this.qty,
    required this.createdAt,
    required this.updatedAt,
    this.productColors,
    this.productImages,
    this.cart,
    this.subOrderProducts,
    this.productOptions,
    this.categoryOpitionValues,
  });
  factory ProductOptionValues.fromJson(Map<String, dynamic> json) =>
      ProductOptionValues(
        id: json['id'],
        productOptionId: json['product_option_id'],
        productColorId: json['product_color_id'],
        productImageId: json['product_image_id'],
        value: json['value'],
        qty: json['qty'],
        categoryOpitionValues: json['category_option_values'] != null? CategoryOptionValues.fromJson(json['category_option_values']): null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        productColors: json['product_colors'] != null ? ProductColors.fromJson(json['product_colors']) : null,
        productImages: json['product_images'] != null ? ProductImages.fromJson(json['product_images']) : null,
        cart: json['cart'] != null
            ? List.generate(
                json['cart']!.length, (i) => Cart.fromJson(json['cart']![i]))
            : [],
        subOrderProducts: json['sub_order_products'] != null
            ? List.generate(
                json['sub_order_products']!.length,
                (i) =>
                    SubOrderProducts.fromJson(json['sub_order_products']![i]))
            : [],
        productOptions: json['product_options'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['product_option_id'] = productOptionId;
    map['product_color_id'] = productColorId;
    map['product_image_id'] = productImageId;
    map['value'] = value;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt.toIso8601String();
    map['product_colors'] = productColors;
    map['product_images'] = productImages;
    map['cart'] = cart != null
        ? List.generate(cart!.length, (i) => cart![i].toJson())
        : [];
    map['sub_order_products'] = subOrderProducts != null
        ? List.generate(
            subOrderProducts!.length, (i) => subOrderProducts![i].toJson())
        : [];
    map['product_options'] = productOptions;

    return map;
  }
}
