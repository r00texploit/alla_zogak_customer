import './category_options.dart';
import './products.dart';

class Categories {
  int id;
  String nameAr;
  String nameEn;
  int? count;
  String? photo;
  DateTime createdAt;
  DateTime updatedAt;
  List<CategoryOptions>? categoryOptions;
  List<Products>? products;

  Categories(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.createdAt,
      required this.updatedAt,
      this.photo,
      this.categoryOptions,
      this.products,
      this.count});
  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json['id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
        count: json['tot'],
        photo: json['photo'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        categoryOptions: json['category_options'] != null
            ? List.generate(json['category_options']!.length,
                (i) => CategoryOptions.fromJson(json['category_options']![i]))
            : [],
        products: json['products'] != null
            ? List.generate(json['products']!.length,
                (i) => Products.fromJson(json['products']![i]))
            : [],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt.toIso8601String();
    map['category_options'] = categoryOptions != null
        ? List.generate(
            categoryOptions!.length, (i) => categoryOptions![i].toJson())
        : [];
    map['products'] = products != null
        ? List.generate(products!.length, (i) => products![i].toJson())
        : [];

    return map;
  }
}
