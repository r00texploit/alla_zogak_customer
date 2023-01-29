import 'dart:developer';

import 'package:alla_zogak_customer/api/category.dart';
import 'package:alla_zogak_customer/api/product.dart';
import 'package:alla_zogak_customer/models/categories.dart';
import 'package:alla_zogak_customer/models/category_options.dart';
import 'package:alla_zogak_customer/models/products.dart';
import 'package:alla_zogak_customer/providers/user_provider.dart';
import 'package:alla_zogak_customer/screens/sub_category_details.dart';
import 'package:alla_zogak_customer/widgets/product_card.dart';
import 'package:alla_zogak_customer/widgets/shimmer.dart';
import 'package:alla_zogak_customer/widgets/theme/theme_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:alla_zogak_customer/models/response_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubCategory extends StatefulWidget {
  SubCategory({super.key});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  UserBloc? user;
  int? catOption;
  int limit = 10;
  int? selectedCat;
  int currentPage = 1;
  int pages = 0;
  bool loading = false;
  List<Products> _productList = [];
  List<Categories> categories = [];
  ThemeModel themeNotifier = ThemeModel();

  int? status;

  Future<void>? _initProductData;
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user!.loadData(context);
    });
    loadCategories();
    super.initState();
  }

  // loadCategories() async {
  //   ResponseModel resp = await getAllCategories();
  //   if (resp.success) {
  //     List<Categories> list = List.generate(
  //         resp.data.length, (i) => Categories.fromJson(resp.data[i]));
  //     for (var cat in list) {
  //       // ResponseModel subs = await getSubCategories(cat.id);
  //       // cat.categoryOptions = List.generate(
  //       //     subs.data.length, (i) => CategoryOptions.fromJson(subs.data[i]));
  //       setState(() {
  //         if (cat.categoryOptions!.isNotEmpty) {
  //           categories.add(cat);
  //         }
  //       });
  //     }
  //     selectedCat = categories[0].id;
  //     catOption = categories[0].categoryOptions![0].id;
  //     //_initProductData = _initProducts();
  //   } else {
  //     if (kDebugMode) {
  //       print(resp.message);
  //     }
  //   }
  // }
  var catid;
  loadCategories() async {
    // valueonseModel value =
    await getAllCategories().then((value) async {
      if (value.success) {
        List<Categories> list = List.generate(
            value.data.length, (i) => Categories.fromJson(value.data[i]));
        for (var cat in list) {
          //ResponseModel subs =
          await getSubCategories(cat.id).then((value) {
            cat.categoryOptions = List.generate(value.data.length,
                (i) => CategoryOptions.fromJson(value.data[i]));
            setState(() {
              if (cat.categoryOptions!.isNotEmpty) {
                categories.add(cat);
              }
            });
          });
        }
        setState(() {
          // catid = categories[0].id;

          // catOption = categories[0].categoryOptions![0].id;
          // log("hf:${catid} and : ${catOption}");
          // _initProductData = _initProducts();
        });
      } else {
        if (kDebugMode) {
          print(value.message);
        }
      }
    });
  }

  // Future<void> _initProducts() async {
  //   try {
  //     ResponseModel list =
  //         await getProductsBySub(catOption, limit, (limit * (currentPage - 1)));
  //     setState(() {
  //       status = list.statusCode;
  //     });
  //     _productList = [];
  //     if (list.total != null) {
  //       pages = (list.total! / limit).ceil();
  //     }
  //     for (var i = 0; i < list.data.length; i++) {
  //       setState(() {
  //         _productList.add(Products.fromJson(list.data[i]));
  //       });
  //     }
  //   } catch (e, s) {
  //     if (kDebugMode) {
  //       print([e, s]);
  //     }
  //   }
  // }

  // Future<void> loadProducts() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   currentPage++;
  //   try {
  //     ResponseModel list =
  //         await getProductsBySub(catOption, limit, (limit * (currentPage - 1)));
  //     for (var i = 0; i < list.data.length; i++) {
  //       setState(() {
  //         _productList.add(Products.fromJson(list.data[i]));
  //       });
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  //   setState(() {
  //     loading = false;
  //   });
  // }

  refresh() async {
    setState(() {
      status = 200;
    });
    await loadCategories();
    // _initProductData = _initProducts();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserBloc>(context);
    return Column(children: [
      Container(
        height: 100,
        width: MediaQuery.of(context).size.width - 2,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: selectedCat != null && selectedCat == index
                  ? Colors.black
                  : Colors.white,
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    selectedCat = categories[index].id;
                    catOption = categories[index].categoryOptions![0].id;
                    currentPage = 1;
                  });
                  log("message: ${selectedCat}");
                  //_initProductData = _initProducts();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) =>
                          Details(selectedCat: selectedCat))));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    //color: themeNotifier.isDark != true ? Colors.black :Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeNotifier.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor.withOpacity(
                              categories[index].id == selectedCat ? 0.5 : 0),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: categories[index].photo != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      "https://yoo2.smart-node.net${categories[index].photo}",
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/3.png",
                                    fit: BoxFit.fill,
                                    scale: 1,
                                    errorBuilder: (context, error, stackTrace) {
                                      if (kDebugMode) {
                                        print(error);
                                      }
                                      return const Icon(Icons.info);
                                    },
                                  ),
                                )
                              : Image.asset(
                                  "assets/3.png",
                                  fit: BoxFit.fill,
                                  scale: 1,
                                  errorBuilder: (context, error, stackTrace) {
                                    if (kDebugMode) {
                                      print(error);
                                    }
                                    return const Icon(Icons.info);
                                  },
                                ),
                        ),
                        Center(
                            child: categories[index].id == selectedCat
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        categories[index].nameAr,
                                        style: GoogleFonts.cairo().copyWith(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        categories[index].nameAr,
                                        style: GoogleFonts.cairo().copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87, // here
                                        ),
                                      ),
                                    ],
                                  )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // if (selectedCat != null)
      // Container(
      //   height: 100,
      //   width: MediaQuery.of(context).size.width,
      //   decoration: BoxDecoration(
      //       color: themeNotifier.isDark
      //           ? Theme.of(context).primaryColor
      //           : Colors.white,
      //       borderRadius: const BorderRadius.only(
      //           topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      //   padding: const EdgeInsets.all(5),
      //   child: ListView.builder(
      //     shrinkWrap: true,
      //     scrollDirection: Axis.horizontal,
      //     itemCount: categories
      //         .firstWhere((el) => el.id == selectedCat)
      //         .categoryOptions
      //         ?.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Material(
      //         color: selectedCat == index && index != 2
      //             ? Colors.black
      //             : Colors.white,
      //         child: GestureDetector(
      //           onTap: () {
      //             setState(() {
      //               catOption = categories
      //                   .firstWhere((el) => el.id == selectedCat)
      //                   .categoryOptions![index]
      //                   .id;
      //               currentPage = 1;
      //             });
      //             _initProductData = _initProducts();
      //           },
      //           child: Padding(
      //             padding: const EdgeInsets.only(right: 15),
      //             child: Container(
      //               height: 25,
      //               padding: const EdgeInsets.symmetric(horizontal: 20),
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(25),
      //                 color: themeNotifier.isDark
      //                     ? Colors.white
      //                     : Theme.of(context).primaryColor.withOpacity(
      //                         categories
      //                                     .firstWhere((el) =>
      //                                         el.id == selectedCat)
      //                                     .categoryOptions![index]
      //                                     .id ==
      //                                 catOption
      //                             ? 0.6
      //                             : 0),
      //               ),
      //               child: Column(
      //                 children: [
      //                   SizedBox(
      //                     width: 45,
      //                     height: 45,
      //                     child: categories
      //                                 .firstWhere(
      //                                     (el) => el.id == selectedCat)
      //                                 .categoryOptions![index]
      //                                 .photo !=
      //                             null
      //                         ? CachedNetworkImage(
      //                             imageUrl:
      //                                 "https://yoo2.smart-node.net${categories.firstWhere((el) => el.id == selectedCat).categoryOptions![index].photo}",
      //                             progressIndicatorBuilder: (context, url,
      //                                     downloadProgress) =>
      //                                 CircularProgressIndicator(
      //                                     value: downloadProgress.progress),
      //                             errorWidget: (context, url, error) =>
      //                                 Image.asset(
      //                               "assets/3.png",
      //                               fit: BoxFit.fill,
      //                               scale: 1,
      //                               errorBuilder:
      //                                   (context, error, stackTrace) {
      //                                 if (kDebugMode) {
      //                                   print(error);
      //                                 }
      //                                 return const Icon(Icons.info);
      //                               },
      //                             ),
      //                           )
      //                         : Image.asset(
      //                             "assets/3.png",
      //                             fit: BoxFit.fill,
      //                             scale: 1,
      //                             errorBuilder: (context, error, stackTrace) {
      //                               if (kDebugMode) {
      //                                 print(error);
      //                               }
      //                               return const Icon(Icons.info);
      //                             },
      //                           ),
      //                   ),
      //                   Center(
      //                     child: categories
      //                                 .firstWhere(
      //                                     (el) => el.id == selectedCat)
      //                                 .categoryOptions![index]
      //                                 .id ==
      //                             catOption
      //                         ? Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Text(
      //                                 categories
      //                                     .firstWhere((el) =>
      //                                         el.id == selectedCat)
      //                                     .categoryOptions![index]
      //                                     .categoryOption,
      //                                 style: GoogleFonts.cairo().copyWith(
      //                                   fontSize: 13,
      //                                   fontWeight: FontWeight.bold,
      //                                 ),
      //                               ),
      //                             ],
      //                           )
      //                         : Column(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Text(
      //                                 categories
      //                                     .firstWhere((el) =>
      //                                         el.id == selectedCat)
      //                                     .categoryOptions![index]
      //                                     .categoryOption,
      //                                 style: GoogleFonts.cairo().copyWith(
      //                                   fontSize: 13,
      //                                   fontWeight: FontWeight.bold,
      //                                   color: Colors.black87,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
      // if (_initProductData == null)
      //   const BuildShimmer(
      //     itemCount: 4,
      //     crossItems: 2,
      //   ),
      // if (_initProductData != null)
      //   FutureBuilder(
      //       future: _initProductData,
      //       builder: (c, snapshot) {
      //         switch (snapshot.connectionState) {
      //           case ConnectionState.none:
      //           case ConnectionState.waiting:
      //           case ConnectionState.active:
      //             {
      //               return const BuildShimmer(
      //                 itemCount: 4,
      //                 crossItems: 2,
      //               );
      //             }
      //           case ConnectionState.done:
      //             {
      //               if (_productList.isEmpty) {
      //                 return const Center(
      //                   child: Text("ليس هنالك منتجات"),
      //                 );
      //               } else {
      //                 return Wrap(
      //                   // padding: const EdgeInsets.all(20),
      //                   // crossAxisCount: 2,
      //                   // shrinkWrap: true,
      //                   // childAspectRatio: 0.8,
      //                   // physics: const BouncingScrollPhysics(),
      //                   // mainAxisSpacing: 15,
      //                   // crossAxisSpacing: 10,
      //                   children: List.generate(
      //                     _productList.length,
      //                     (i) {
      //                       return Padding(
      //                         padding: const EdgeInsets.all(5),
      //                         child: SizedBox(
      //                           width:
      //                               MediaQuery.of(context).size.width / 2 - 20,
      //                           child: ProductCard(product: _productList[i]),
      //                         ),
      //                       );
      //                     },
      //                   ),
      //                 );
      //               }
      //             }
      //         }
      //       }),
      //if (selectedCat != null)
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     if (currentPage != pages)
      //       ElevatedButton.icon(
      //         onPressed: () async {
      //           if (!loading) {
      //             //await loadProducts();
      //           }
      //         },
      //         icon: loading
      //             ? const Padding(
      //                 padding: EdgeInsets.all(5.0),
      //                 child: CircularProgressIndicator(
      //                   color: Colors.white,
      //                 ),
      //               )
      //             : const Icon(Icons.grid_view_outlined),
      //         label: loading
      //             ? const Text('')
      //             : Text(
      //                 "عرض المزيد من ${categories.firstWhere((el) => el.id == selectedCat).nameAr}"),
      //       ),
      //   ],
      // )
    ]);
  }
}
