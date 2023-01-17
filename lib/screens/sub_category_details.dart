import 'package:alla_zogak_customer/api/category.dart';
import 'package:alla_zogak_customer/api/product.dart';
import 'package:alla_zogak_customer/models/categories.dart';
import 'package:alla_zogak_customer/models/products.dart';
import 'package:alla_zogak_customer/models/response_model.dart';
import 'package:alla_zogak_customer/widgets/product_card.dart';
import 'package:alla_zogak_customer/widgets/shimmer.dart';
import 'package:alla_zogak_customer/widgets/theme/theme_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Details extends StatefulWidget {
  int? selectedCat;
  Details({super.key, this.selectedCat});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int? catOption;
  int limit = 10;

  int currentPage = 1;
  int pages = 0;
  bool loading = false;
  List<Products> _productList = [];
  List<Categories> categories = [];

  Future<void>? _initProductData;
  @override
  void initState() {
    loadCategories();
    super.initState();
  }

  int? status;
  loadCategories() async {
    ResponseModel resp = await getAllCategories();
    if (resp.success) {
      List<Categories> list = List.generate(
          resp.data.length, (i) => Categories.fromJson(resp.data[i]));
      for (var cat in list) {
        setState(() {
          if (cat.categoryOptions!.isNotEmpty) {
            categories.add(cat);
          }
        });
      }
      widget.selectedCat = categories[0].id;
      catOption = categories[0].categoryOptions![0].id;
      _initProductData = _initProducts();
    } else {
      if (kDebugMode) {
        print(resp.message);
      }
    }
  }

  Future<void> _initProducts() async {
    try {
      ResponseModel list =
          await getProductsBySub(catOption, limit, (limit * (currentPage - 1)));
      setState(() {
        status = list.statusCode;
      });
      _productList = [];
      if (list.total != null) {
        pages = (list.total! / limit).ceil();
      }
      for (var i = 0; i < list.data.length; i++) {
        setState(() {
          _productList.add(Products.fromJson(list.data[i]));
        });
      }
    } catch (e, s) {
      if (kDebugMode) {
        print([e, s]);
      }
    }
  }

  Future<void> loadProducts() async {
    setState(() {
      loading = true;
    });
    currentPage++;
    try {
      ResponseModel list =
          await getProductsBySub(catOption, limit, (limit * (currentPage - 1)));
      for (var i = 0; i < list.data.length; i++) {
        setState(() {
          _productList.add(Products.fromJson(list.data[i]));
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      loading = false;
    });
  }

  ThemeModel themeNotifier = ThemeModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" الفئات الفرعية" ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: themeNotifier.isDark
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories
                    .firstWhere((el) => el.id == widget.selectedCat)
                    .categoryOptions
                    ?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                    color: widget.selectedCat == index && index != 2
                        ? Colors.black
                        : Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          catOption = categories
                              .firstWhere((el) => el.id == widget.selectedCat)
                              .categoryOptions![index]
                              .id;
                          currentPage = 1;
                        });
                        _initProductData = _initProducts();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Container(
                          height: 25,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: themeNotifier.isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor.withOpacity(
                                    categories
                                                .firstWhere((el) =>
                                                    el.id == widget.selectedCat)
                                                .categoryOptions![index]
                                                .id ==
                                            catOption
                                        ? 0.6
                                        : 0),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 45,
                                height: 45,
                                child: categories
                                            .firstWhere((el) =>
                                                el.id == widget.selectedCat)
                                            .categoryOptions![index]
                                            .photo !=
                                        null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "https://yoo2.smart-node.net${categories.firstWhere((el) => el.id == widget.selectedCat).categoryOptions![index].photo}",
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          "assets/3.png",
                                          fit: BoxFit.fill,
                                          scale: 1,
                                          errorBuilder:
                                              (context, error, stackTrace) {
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          if (kDebugMode) {
                                            print(error);
                                          }
                                          return const Icon(Icons.info);
                                        },
                                      ),
                              ),
                              Center(
                                child: categories
                                            .firstWhere((el) =>
                                                el.id == widget.selectedCat)
                                            .categoryOptions![index]
                                            .id ==
                                        catOption
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            categories
                                                .firstWhere((el) =>
                                                    el.id == widget.selectedCat)
                                                .categoryOptions![index]
                                                .categoryOption,
                                            style: GoogleFonts.cairo().copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            categories
                                                .firstWhere((el) =>
                                                    el.id == widget.selectedCat)
                                                .categoryOptions![index]
                                                .categoryOption,
                                            style: GoogleFonts.cairo().copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_initProductData == null)
              const BuildShimmer(
                itemCount: 4,
                crossItems: 2,
              ),
            if (_initProductData != null)
              FutureBuilder(
                  future: _initProductData,
                  builder: (c, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        {
                          return const BuildShimmer(
                            itemCount: 4,
                            crossItems: 2,
                          );
                        }
                      case ConnectionState.done:
                        {
                          if (_productList.isEmpty) {
                            return const Center(
                              child: Text("ليس هنالك منتجات"),
                            );
                          } else {
                            return Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: _productList.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        Wrap(
                                          children: 
                                            [Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    20,
                                                child: ProductCard(
                                                    product: _productList[index]),
                                              ),
                                            ),
                                          ],
                                        )));
                            // },
                            //),
                            // );
                          }
                        }
                    }
                  }),
          ],
        ),
      ),
    );
  }
}
