class Panner {
  // int id;
  // int vendorId;
  // int productCategoryId;
  String image;
  // String description;
  // bool verified;
  // int price;
  // int? discount;
  // DateTime createdAt;
  // DateTime? updatedAt;
  // Categories? categories;
  // List<Cart>? cart;
  // List<ProductImages>? productImages;
  // List<ProductOptions>? productOptions;
  // List<SubOrderProducts>? subOrderProducts;
  // Vendors? vendors;

  Panner({
    required this.image,
    // required this.vendorId,
    // required this.productCategoryId,
    // required this.name,
    // required this.description,
    // required this.verified,
    // required this.createdAt,
    // required this.price,
    // this.discount,
    // this.updatedAt,
    // this.categories,
    // this.cart,
    // this.productImages,
    // this.productOptions,
    // this.subOrderProducts,
    // this.vendors,
  });
  factory Panner.fromJson(Map<String, dynamic> json) => Panner(
      // ignore: prefer_interpolation_to_compose_strings
      image: "https://yoo2.smart-node.net" + json["image"]);
}
