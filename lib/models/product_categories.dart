class ProductCategories {
  int id;
  String nameAr;
  String nameEn;

  ProductCategories({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
  factory ProductCategories.fromJson(Map<String, dynamic> json) =>
      ProductCategories(
        id: json['id'],
        nameAr: json['name_ar'],
        nameEn: json['name_en'],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name_ar'] = nameAr;
    map['name_en'] = nameEn;

    return map;
  }
}
