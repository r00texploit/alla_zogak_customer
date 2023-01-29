// import 'dart:developer';

// import 'package:alla_zogak_customer/api/product.dart';
// import 'package:alla_zogak_customer/models/products.dart';
// import 'package:alla_zogak_customer/widgets/product_card.dart';
// import 'package:alla_zogak_customer/widgets/shimmer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// import '../models/response_model.dart';

// class TopTenScreen extends StatefulWidget {
//   // List<Products> productList;
//   // Future<void>? initProductData;
//   TopTenScreen({super.key});

//   @override
//   State<TopTenScreen> createState() => _TopTenScreenState();
// }

// class _TopTenScreenState extends State<TopTenScreen> {
//   int? selectedCat = 0;
//   int? catOption = 0;
//   int limit = 10;
//   int currentPage = 1;
//   int pages = 0;
//   bool loading = false;
//   List<Products> _productList = [];
//   Future<void>? _initProductData;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _initProductData = _initProducts();
//   }

//   int? status;
//   Future<void> _initProducts() async {
//     try {
//       log("cat ${catOption}");
//       ResponseModel list =
//           await getProductsBySub(catOption, limit, (limit * (currentPage - 1)));
//       setState(() {
//         status = list.statusCode;
//       });
//       _productList = [];
//       // if (list.total != null) {
//       //   pages = (list.total! / limit).ceil();
//       // }
//       for (var i = 0; i < list.data.length; i++) {
//         setState(() {
//           _productList.add(Products.fromJson(list.data[i]));
//         });
//       }
//     } catch (e, s) {
//       if (kDebugMode) {
//         print([e, s]);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FutureBuilder(
//           future: _initProducts(),
//           builder: (c, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.none:
//               case ConnectionState.waiting:
//               case ConnectionState.active:
//                 {
//                   return const BuildShimmer(
//                     itemCount: 4,
//                     crossItems: 2,
//                   );
//                 }
//               case ConnectionState.done:
//                 {
//                   if (_productList.isEmpty) {
//                     return const Center(
//                       child: Text("ليس هنالك منتجات"),
//                     );
//                   } else {
//                     return Wrap(
//                       // padding: const EdgeInsets.all(20),
//                       // crossAxisCount: 2,
//                       // shrinkWrap: true,
//                       // childAspectRatio: 0.8,
//                       // physics: const BouncingScrollPhysics(),
//                       // mainAxisSpacing: 15,
//                       // crossAxisSpacing: 10,
//                       children: List.generate(
//                         _productList.length,
//                         (i) {
//                           return Padding(
//                             padding: const EdgeInsets.all(5),
//                             child: SizedBox(
//                               width: MediaQuery.of(context).size.width / 2 - 20,
//                               child: ProductCard(product: _productList[i]),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }
//                 }
//             }
//           }),
//     );
//   }
// }
