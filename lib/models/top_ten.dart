import './categories.dart';
import './cart.dart';
import './product_images.dart';
import './product_options.dart';
import './sub_order_products.dart';
import './vendors.dart';

class TopTen {
  int id;
  int vendorId;
  int productCategoryId;
  String name;
  String description;
  bool verified;
  int price;
  int? discount;
  DateTime createdAt;
  DateTime? updatedAt;
  Categories? categories;
  List<Cart>? cart;
  List<ProductImages>? productImages;
  List<ProductOptions>? productOptions;
  List<SubOrderProducts>? subOrderProducts;
  Vendors? vendors;

  TopTen({
    required this.id,
    required this.vendorId,
    required this.productCategoryId,
    required this.name,
    required this.description,
    required this.verified,
    required this.createdAt,
    required this.price,
    this.discount,
    this.updatedAt,
    this.categories,
    this.cart,
    this.productImages,
    this.productOptions,
    this.subOrderProducts,
    this.vendors,
  });
  factory TopTen.fromJson(Map<String, dynamic> json) => TopTen(
        id: json['id'],
        vendorId: json['vendor_id'],
        productCategoryId: json['product_category_id'],
        name: json['name'],
        price: json['price'],
        discount: json['discount'],
        description: json['description'],
        verified: json['verified'] == 1? true : false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        categories: json['categories'] != null ?Categories.fromJson(json['categories']) : null,
        cart: json['cart'] != null
            ? List.generate(
                json['cart']!.length, (i) => Cart.fromJson(json['cart']![i]))
            : [],
        productImages: json['product_images'] != null
            ? List.generate(json['product_images']!.length,
                (i) => ProductImages.fromJson(json['product_images']![i]))
            : [],
        productOptions: json['product_options'] != null
            ? List.generate(json['product_options']!.length,
                (i) => ProductOptions.fromJson(json['product_options']![i]))
            : [],
        subOrderProducts: json['sub_order_products'] != null
            ? List.generate(
                json['sub_order_products']!.length,
                (i) =>
                    SubOrderProducts.fromJson(json['sub_order_products']![i]))
            : [],
        vendors: json['vendors'] != null ?Vendors.fromJson(json['vendors']) : null,
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['vendor_id'] = vendorId;
    map['product_category_id'] = productCategoryId;
    map['name'] = name;
    map['description'] = description;
    map['verified'] = verified;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    map['categories'] = categories;
    map['cart'] = cart != null
        ? List.generate(cart!.length, (i) => cart![i].toJson())
        : [];
    map['product_images'] = productImages != null
        ? List.generate(
            productImages!.length, (i) => productImages![i].toJson())
        : [];
    map['product_options'] = productOptions != null
        ? List.generate(
            productOptions!.length, (i) => productOptions![i].toJson())
        : [];
    map['sub_order_products'] = subOrderProducts != null
        ? List.generate(
            subOrderProducts!.length, (i) => subOrderProducts![i].toJson())
        : [];
    map['vendors'] = vendors;

    return map;
  }
}
