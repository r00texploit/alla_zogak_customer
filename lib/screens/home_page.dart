import 'package:alla_zogak_customer/widgets/drawer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../api/category.dart';
import '../models/categories.dart';
import '../models/products.dart';
import '../models/response_model.dart';
import '../providers/wishlist_provider.dart';
import '../screens/search_screen.dart';
import '../widgets/shimmer.dart';
import '../api/product.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/product_card.dart';
import 'cart.dart';
import 'my_orders.dart';
import 'wishlist.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late CartBloc cart;
  late UserBloc user;
  late WishlistBloc wishlist;
  int _currentIndex = 0;

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      // containerHeight: 70,
      backgroundColor: Colors.white,
      selectedLabelStyle: GoogleFonts.cairo().copyWith(color: Colors.black54),
      unselectedLabelStyle: GoogleFonts.cairo().copyWith(color: Colors.black54),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      unselectedFontSize: 14,
      selectedFontSize: 14,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SearchScreen(width: MediaQuery.of(context).size.width),
            ),
          );
        } else {
          setState(() => _currentIndex = index);
        }
      },
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(
                Icons.shopping_cart,
              ),
              if (cart.itemCount != 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        cart.itemCount < 9 ? cart.itemCount.toString() : '+9',
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          label: 'العربة',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            size: 35,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(
                Icons.favorite,
              ),
              if (wishlist.total != 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        wishlist.total < 9 ? wishlist.total.toString() : '+9',
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          label: 'المفضله',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.card_giftcard_outlined,
          ),
          label: 'طلباتي',
        ),
      ],
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      const HomeScreen(),
      const MyCart(),
      const Text(""),
      const Wishlist(),
      const MyOrder(),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    cart = Provider.of<CartBloc>(context);
    user = Provider.of<UserBloc>(context);
    wishlist = Provider.of<WishlistBloc>(context);
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            _key.currentState?.openDrawer();
          },
          child: const Icon(
            Icons.menu,
            size: 35,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 45,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SearchScreen(width: MediaQuery.of(context).size.width),
                ),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: getBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserBloc user;
  int status = 200;
  List<Categories> categories = [];
  int? selectedCat;
  int? catOption;
  int limit = 10;
  int currentPage = 1;
  int pages = 0;
  bool loading = false;
  List<Products> _productList = [];
  Future<void>? _initProductData;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user.loadData(context);
    });
    loadCategories();
    super.initState();
  }

  loadCategories() async {
    ResponseModel resp = await getAllCategories();
    if (resp.success) {
      List<Categories> list = List.generate(
          resp.data.length, (i) => Categories.fromJson(resp.data[i]));
      for (var cat in list) {
        // ResponseModel subs = await getSubCategories(cat.id);
        // cat.categoryOptions = List.generate(
        //     subs.data.length, (i) => CategoryOptions.fromJson(subs.data[i]));
        setState(() {
          if (cat.categoryOptions!.isNotEmpty) {
            categories.add(cat);
          }
        });
      }
      selectedCat = categories[0].id;
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

  refresh() async {
    setState(() {
      status = 200;
    });
    await loadCategories();
    _initProductData = _initProducts();
  }

  List<String> caro = [
    "https://cdn.shopify.com/s/files/1/0210/2968/3222/articles/trending_products_to_sell_in_India_ad8fc9e0-5052-44bf-bd93-7bec4335f5ee.jpg?v=1647462399",
    "https://img.freepik.com/premium-vector/online-shopping-store-website-mobile-phone-design-smart-business-marketing-concept-horizontal-view-vector-illustration_62391-460.jpg?w=2000",
    "https://www.digitalcommerce360.com/wp-content/uploads/2020/08/Two-thirds-of-consumers-have-increased-online-shopping-because-of-the-coronavirus.png"
  ];

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserBloc>(context);
    return Scaffold(
      body: status == 200
          ? ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: CarouselSlider.builder(
                          itemBuilder: (context, i, realIndex) {
                            return CachedNetworkImage(
                                                imageUrl:
                                                    caro[i],
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  "assets/3.png",
                                                  fit: BoxFit.fill,
                                                  scale: 1,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    if (kDebugMode) {
                                                      print(error);
                                                    }
                                                    return const Icon(
                                                        Icons.info);
                                                  },
                                                ),
                                              );
                          },
                          itemCount: caro.length,
                          options: CarouselOptions(
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                            autoPlayCurve: Curves.easeInOutCubic,
                            enlargeCenterPage: true,
                            pauseAutoPlayOnManualNavigate: false,
                            autoPlay: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
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
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCat = categories[index].id;
                                  catOption =
                                      categories[index].categoryOptions![0].id;
                                  currentPage = 1;
                                });
                                _initProductData = _initProducts();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(
                                            categories[index].id == selectedCat
                                                ? 0.5
                                                : 0),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: categories[index].photo != null
                                            // ? Image(
                                            //     image: PCacheImage(
                                            //         "https://yoo2.smart-node.net${categories[index].photo}",
                                            //         enableCache: true,
                                            //         enableInMemory: true))
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "https://yoo2.smart-node.net${categories[index].photo}",
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  "assets/3.png",
                                                  fit: BoxFit.fill,
                                                  scale: 1,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    if (kDebugMode) {
                                                      print(error);
                                                    }
                                                    return const Icon(
                                                        Icons.info);
                                                  },
                                                ),
                                              )
                                            : Image.asset(
                                                "assets/3.png",
                                                fit: BoxFit.fill,
                                                scale: 1,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  if (kDebugMode) {
                                                    print(error);
                                                  }
                                                  return const Icon(Icons.info);
                                                },
                                              ),
                                      ),
                                      Center(
                                          child: categories[index].id ==
                                                  selectedCat
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      categories[index].nameAr,
                                                      style: GoogleFonts.cairo()
                                                          .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      categories[index].nameAr,
                                                      style: GoogleFonts.cairo()
                                                          .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (selectedCat != null)
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          padding: const EdgeInsets.all(5),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: categories
                                .firstWhere((el) => el.id == selectedCat)
                                .categoryOptions
                                ?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    catOption = categories
                                        .firstWhere(
                                            (el) => el.id == selectedCat)
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(categories
                                                      .firstWhere((el) =>
                                                          el.id == selectedCat)
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
                                                          el.id == selectedCat)
                                                      .categoryOptions![index]
                                                      .photo !=
                                                  null
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      "https://yoo2.smart-node.net${categories.firstWhere((el) => el.id == selectedCat).categoryOptions![index].photo}",
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    "assets/3.png",
                                                    fit: BoxFit.fill,
                                                    scale: 1,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      if (kDebugMode) {
                                                        print(error);
                                                      }
                                                      return const Icon(
                                                          Icons.info);
                                                    },
                                                  ),
                                                )
                                              : Image.asset(
                                                  "assets/3.png",
                                                  fit: BoxFit.fill,
                                                  scale: 1,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    if (kDebugMode) {
                                                      print(error);
                                                    }
                                                    return const Icon(
                                                        Icons.info);
                                                  },
                                                ),
                                        ),
                                        Center(
                                          child: categories
                                                      .firstWhere((el) =>
                                                          el.id == selectedCat)
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
                                                              el.id ==
                                                              selectedCat)
                                                          .categoryOptions![
                                                              index]
                                                          .categoryOption,
                                                      style: GoogleFonts.cairo()
                                                          .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                              el.id ==
                                                              selectedCat)
                                                          .categoryOptions![
                                                              index]
                                                          .categoryOption,
                                                      style: GoogleFonts.cairo()
                                                          .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                      if (selectedCat != null)
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
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.grid_view_outlined),
                                label: loading
                                    ? const Text('')
                                    : Text(
                                        "عرض المزيد من ${categories.firstWhere((el) => el.id == selectedCat).nameAr}"),
                              ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/error.png",
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    "آسفين! حدثت مشكلة ما.",
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "لا تقلق يقوم فريقنا الآن بحل المشكلة.",
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: ElevatedButton(
                      onPressed: () => refresh(),
                      child: Text(
                        "أعادة المحاولة",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

//For removing Scroll Glow
class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
