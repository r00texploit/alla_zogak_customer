import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_page.dart';

import '../api/category.dart';
import '../api/product.dart';
import '../models/categories.dart';
import '../models/products.dart';
import '../models/response_model.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer.dart';

class SearchScreen extends StatefulWidget {
  final double width;
  const SearchScreen({Key? key, required this.width}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  TextEditingController search = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  var focusNode = FocusNode();
  List<Categories> categories = [
    Categories(
        id: 0,
        nameAr: "الكل",
        nameEn: "All",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now())
  ];
  late Categories selectedCat;
  int limit = 10;
  int currentPage = 1;
  int pages = 0;
  bool loading = false;
  List<Products> _productList = [];
  late Future<void> _initProductData;
  @override
  void initState() {
    selectedCat = categories[0];
    _initProductData = _initProducts();
    loadCategories();
    super.initState();
    focusNode.requestFocus();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _animation =
        Tween<double>(begin: 60, end: widget.width).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.addListener(() {
      setState(() {});
    });
  }

  loadCategories() async {
    ResponseModel resp = await getAllCategories();
    if (resp.success) {
      List<Categories> list = List.generate(
          resp.data.length, (i) => Categories.fromJson(resp.data[i]));
      for (var cat in list) {
        setState(() {
          categories.add(cat);
        });
      }
    } else {
      if (kDebugMode) {
        print(resp.message);
      }
    }
  }

  toggleFilter() {
    focusNode.unfocus();
    if (_animation.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  Future<void> _initProducts() async {
    try {
      ResponseModel list = await getProducts(
          selectedCat.id, limit, (limit * (currentPage - 1)), search.text);
      _productList = [];
      if (list.total != null) {
        pages = (list.total! / limit).ceil();
      }
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
  }

  Future<void> loadProducts() async {
    setState(() {
      loading = true;
    });
    currentPage++;
    try {
      ResponseModel list = await getProducts(
          selectedCat.id, limit, (limit * (currentPage - 1)), search.text);
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

  changeFilter(String? newValue) {
    setState(() {
      selectedCat = categories.firstWhere(
        (el) => el.id.toString() == newValue,
        orElse: () => categories[0],
      );
      toggleFilter();
      currentPage = 1;
      _initProductData = _initProducts();
    });
  }

  changeSearch(String? newValue) {
    setState(() {
      currentPage = 1;
      _initProductData = _initProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              focusNode: focusNode,
              controller: search,
              keyboardType: TextInputType.text,
              autocorrect: false,
              onChanged: changeSearch,
              decoration: const InputDecoration(
                hintText: 'بحث...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                    return Wrap(
                                      // padding: const EdgeInsets.all(20),
                                      // crossAxisCount: 2,
                                      // shrinkWrap: true,
                                      // childAspectRatio: 0.8,
                                      // physics: const BouncingScrollPhysics(),
                                      // mainAxisSpacing: 15,
                                      // crossAxisSpacing: 10,
                                      children: List.generate(
                                        _productList.length,
                                        (i) {
                                          return Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  20,
                                              child: ProductCard(
                                                  product: _productList[i]),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                }
                            }
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (currentPage != pages)
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (!loading) {
                                  await loadProducts();
                                }
                              },
                              icon: loading
                                  ? const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Icon(Icons.grid_view_outlined),
                              label: loading
                                  ? const Text('')
                                  : Text(
                                      "عرض المزيد من ${categories.firstWhere((el) => el.id == selectedCat.id).nameAr}"),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: _animation.value,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: _animation.isCompleted
                        ? FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelStyle: GoogleFonts.cairo().copyWith(
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                isEmpty: selectedCat.id.toString() == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    dropdownColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.8),
                                    value: selectedCat.id.toString(),
                                    isDense: true,
                                    onChanged: (String? newValue) =>
                                        changeFilter(newValue),
                                    items: categories.map((Categories value) {
                                      return DropdownMenuItem<String>(
                                        value: value.id.toString(),
                                        child: Text(
                                          value.nameAr,
                                          style: GoogleFonts.cairo().copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          )
                        : GestureDetector(
                            onTap: () => toggleFilter(),
                            child: Center(
                              child: Text(
                                selectedCat.nameAr,
                                style: GoogleFonts.cairo().copyWith(
                                  color: Colors.grey,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
