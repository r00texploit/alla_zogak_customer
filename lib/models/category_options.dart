import './categories.dart';
import './category_option_values.dart';

class CategoryOptions {
  int id;
  int categoryId;
  String categoryOption;
  String? photo;
  DateTime createdAt;
  DateTime updatedAt;
  Categories? categories;
  List<CategoryOptionValues>? categoryOptionValues;

  CategoryOptions({
    required this.id,
    required this.categoryId,
    required this.categoryOption,
    this.photo,
    required this.createdAt,
    required this.updatedAt,
    this.categories,
    this.categoryOptionValues,
  });
  factory CategoryOptions.fromJson(Map<String, dynamic> json) =>
      CategoryOptions(
        id: json['id'],
        categoryId: json['category_id'],
        categoryOption: json['category_option'],
        photo: json['photo'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        categories: json['categories'] != null
            ? Categories.fromJson(json['categories'])
            : null,
        categoryOptionValues: json['category_option_values'] != null
            ? List.generate(
                json['category_option_values']!.length,
                (i) => CategoryOptionValues.fromJson(
                    json['category_option_values']![i]))
            : [],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['category_option'] = categoryOption;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt.toIso8601String();
    map['categories'] = categories;
    map['category_option_values'] = categoryOptionValues != null
        ? List.generate(categoryOptionValues!.length,
            (i) => categoryOptionValues![i].toJson())
        : [];

    return map;
  }
}
