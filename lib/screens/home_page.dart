import 'dart:developer';

import 'package:alla_zogak_customer/models/category_options.dart';
import 'package:alla_zogak_customer/models/panner.dart';
import 'package:alla_zogak_customer/screens/sub_category.dart';
import 'package:alla_zogak_customer/widgets/drawer_widget.dart';
import 'package:alla_zogak_customer/widgets/theme/theme_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    //var brightness = MediaQuery.of(context).platformBrightness;
    if (kDebugMode) {
      print(themeNotifier.isDark);
    }
    return BottomNavigationBar(
      // containerHeight: 70,
      backgroundColor: themeNotifier.isDark ? Colors.black : Colors.white,
      selectedLabelStyle: GoogleFonts.cairo().copyWith(color: Colors.black54),
      unselectedLabelStyle: GoogleFonts.cairo().copyWith(color: Colors.black54),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      unselectedFontSize: 14,
      selectedFontSize: 14,
      currentIndex: _currentIndex,
      onTap: (index) {
        // if (index == 2) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           SearchScreen(width: MediaQuery.of(context).size.width),
        //     ),
        //   );
        // } else {
        setState(() => _currentIndex = index);
        // },
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
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        cart.itemCount < 9 ? cart.itemCount.toString() : '+9',
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 8,
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
        // const BottomNavigationBarItem(
        //   icon: Icon(
        //     Icons.search,
        //     size: 35,
        //   ),
        //   label: '',
        // ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(
                Icons.favorite,
              ),
              if (wishlist.total != 0)
                Positioned(
                  right: 0,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        wishlist.total < 9 ? wishlist.total.toString() : '+9',
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 8,
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
      // const Text(""),
      const Wishlist(),
      const MyOrder(),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }

  ThemeModel themeNotifier = ThemeModel();
  @override
  Widget build(BuildContext context) {
    cart = Provider.of<CartBloc>(context);
    user = Provider.of<UserBloc>(context);
    wishlist = Provider.of<WishlistBloc>(context);

    return Scaffold(
      key: _key,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
            color: Colors.grey,
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
            color: Colors.grey,
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
  ThemeModel themeNotifier = ThemeModel();
  var pan;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      user.loadData(context);
    });
    loading = true;
    loadCategories();
    pan = getpremossion();
    super.initState();
    _initProductData = _initProducts();
  }

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
          catid = categories[0].id;
          loading = false;
          catOption = categories[0].categoryOptions![0].id;
          log("hf:${catid} and : ${catOption}");
          _initProductData = _initProducts();
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
  //     final sh = await SharedPreferences.getInstance();
  //     final dio = Dio(BaseOptions(baseUrl: 'https://yoo2.smart-node.net/api'));
  //     var list = await dio.get(
  //       "/top-ten-products",
  //       options: Options(
  //         headers: {"token": sh.getString("token")},
  //       ),
  //     );

  //     _productList = [];
  //     log("data :${list.data["data"]}");
  //     var prd;
  //     for (var i = 0; i < list.data.length; i++) {
  //       log("product $i: ${list.data["data"][i]}");
  //       setState(() {
  //         prd = Products.fromJson(list.data["data"][i]);
  //         _productList.add(Products.fromJson(list.data["data"][i]));

  //       });
  //     }

  //     log("fdsa $prd");
  //     if (!prd.id.isNegative) {
  //       setState(() {
  //         status = 200;
  //         loading = true;
  //       });
  //       log("init :${prd.runtimeType}");

  //       // if (prd.total != null) {
  //       //   pages = (prd.total! / limit).ceil();
  //       // }

  //       //}}else{
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   } catch (e, s) {
  //     if (kDebugMode) {
  //       print([e, s]);
  //     }
  //   }
  // }

  Future<void> _initProducts() async {
    try {
      //log("mq :${MediaQuery.of(context).size.width}");
      // ResponseModel list =
      await getProductsBySub(catOption, limit, (limit * (currentPage - 1)))
          .then((value) {
        setState(() {
          status = value.statusCode;
        });
        _productList = [];
        if (value.total != null) {
          pages = (value.total! / limit).ceil();
        }
        for (var i = 0; i < value.data.length; i++) {
          setState(() {
            _productList.add(Products.fromJson(value.data[i]));
          });
        }
        setState(() {
          loading = false;
        });
      });
    } catch (e, s) {
      if (kDebugMode) {
        print([e.toString(), s.toString()]);
        loading = false;
      }
    }
  }

  refresh() async {
    setState(() {
      status = 200;
    });
    // await loadCategories();
    _initProductData = _initProducts();
  }

  List<Panner> caro = [];

  getpremossion() async {
    // loading = true;
    try {
      await getPanner().then((value) {
        loading = true;
        log("message33: $value");
        setState(() {
          status = value.statusCode;
        });
        // _productList = [];
        // if (value.total != null) {
        //   pages = (value.total! / limit).ceil();
        // }
        for (var i = 0; i < value.data.length; i++) {
          log("meCssage4:${value.data.length}");
          setState(() {
            // ignore: prefer_interpolation_to_compose_strings
            // var str = "https://yoo2.smart-node.net/" + value.data[i]["image"];
            // log("message1: ${caro[i].image}");
            caro.add(Panner.fromJson(value.data[i]));
            log("message2: ${caro[i].image}");
          });
        }
        // setState(() {
        //   loading = false;
        // });
      });
    } catch (e, s) {
      if (kDebugMode) {
        print([e.toString(), s.toString()]);
        loading = false;
      }
    }
  }

  // [
  //   "https://yoo2.smart-node.net/images/310F15F7052020EEBDCE.jpg",
  //   "https://yoo2.smart-node.net/images/981DA98B5AF10D00EC7D.jpg",
  //   "https://yoo2.smart-node.net/images/534DE410806C81619375.jpg"
  //   // "https://cdn.shopify.com/s/files/1/0210/2968/3222/articles/trending_products_to_sell_in_India_ad8fc9e0-5052-44bf-bd93-7bec4335f5ee.jpg?v=1647462399",
  //   // "https://img.freepik.com/premium-vector/online-shopping-store-website-mobile-phone-design-smart-business-marketing-concept-horizontal-view-vector-illustration_62391-460.jpg?w=2000",
  //   // "https://www.digitalcommerce360.com/wp-content/uploads/2020/08/Two-thirds-of-consumers-have-increased-online-shopping-because-of-the-coronavirus.png"
  // ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserBloc>(context);
    status = 200;

    CarouselController controller = CarouselController();
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
                      // const Text(
                      //   "",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                        height: 215,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            CarouselSlider.builder(
                              carouselController: controller,
                              itemBuilder: (context, i, realIndex) {
                                return CachedNetworkImage(
                                  imageUrl: caro[i].image,
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
                                );
                              },
                              itemCount: 3,
                              options: CarouselOptions(
                                // enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                                // autoPlayCurve: Curves.easeInOutCubic,
                                // enlargeCenterPage: true,
                                // pauseAutoPlayOnManualNavigate: false,
                                // enableInfiniteScroll: false,
                                viewportFraction: 1,
                                // aspectRatio: 2.0,
                                autoPlay: true,
                                padEnds: false,
                                onPageChanged: (index, reason) {
                                  currentIndex = index;

                                  setState(() {});
                                  // reason
                                },
                              ),
                            ),
                            AnimatedSmoothIndicator(
                              activeIndex: currentIndex,
                              count: 3,
                              effect: JumpingDotEffect(
                                  dotHeight: 10,
                                  dotWidth: 10,
                                  dotColor: Colors.grey,
                                  activeDotColor:
                                      Theme.of(context).primaryColor),
                            ),
                            // DotsIndicator(
                            //   dotsCount: caro.length,
                            //   position: currentIndex.toDouble(),
                            //   onTap: (position) => controller.nextPage(
                            //       duration: const Duration(milliseconds: 300),
                            //       curve: Curves.linear),
                            // )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SubCategory(),

                      //           Container(
                      //             height: 100,
                      //             width: MediaQuery.of(context).size.width,
                      //             decoration: const BoxDecoration(
                      //               borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(10),
                      //                 topRight: Radius.circular(10),
                      //               ),
                      //             ),
                      //             padding: const EdgeInsets.all(5),
                      //             child: ListView.builder(
                      //               shrinkWrap: true,
                      //               scrollDirection: Axis.horizontal,
                      //               itemCount: categories.length,
                      //               itemBuilder: (BuildContext context, int index) {
                      //                 return Material(
                      //                   color: selectedCat != null && selectedCat == index
                      //                       ? Colors.black
                      //                       : Colors.white,
                      //                   child: GestureDetector(
                      //                     onTap: () {
                      //                       setState(() {
                      //                         selectedCat = categories[index].id;
                      //                         catOption = categories[index]
                      //                             .categoryOptions![0]
                      //                             .id;
                      //                         currentPage = 1;
                      //                       });
                      //                       _initProductData = _initProducts();
                      //                     },
                      //                     child: Padding(
                      //                       padding: const EdgeInsets.only(right: 15),
                      //                       child: Container(
                      //                         //color: themeNotifier.isDark != true ? Colors.black :Colors.white,
                      //                         padding: const EdgeInsets.symmetric(
                      //                           horizontal: 20,
                      //                           vertical: 3,
                      //                         ),
                      //                         decoration: BoxDecoration(
                      //                           borderRadius: BorderRadius.circular(10),
                      //                           color: themeNotifier.isDark
                      //                               ? Colors.white
                      //                               : Theme.of(context)
                      //                                   .primaryColor
                      //                                   .withOpacity(
                      //                                       categories[index].id ==
                      //                                               selectedCat
                      //                                           ? 0.5
                      //                                           : 0),
                      //                         ),
                      //                         child: Column(
                      //                           children: [
                      //                             SizedBox(
                      //                               width: 45,
                      //                               height: 45,
                      //                               child: categories[index].photo != null
                      //                                   ? CachedNetworkImage(
                      //                                       imageUrl:
                      //                                           "https://yoo2.smart-node.net${categories[index].photo}",
                      //                                       progressIndicatorBuilder: (context,
                      //                                               url,
                      //                                               downloadProgress) =>
                      //                                           CircularProgressIndicator(
                      //                                               value:
                      //                                                   downloadProgress
                      //                                                       .progress),
                      //                                       errorWidget:
                      //                                           (context, url, error) =>
                      //                                               Image.asset(
                      //                                         "assets/3.png",
                      //                                         fit: BoxFit.fill,
                      //                                         scale: 1,
                      //                                         errorBuilder: (context,
                      //                                             error, stackTrace) {
                      //                                           if (kDebugMode) {
                      //                                             print(error);
                      //                                           }
                      //                                           return const Icon(
                      //                                               Icons.info);
                      //                                         },
                      //                                       ),
                      //                                     )
                      //                                   : Image.asset(
                      //                                       "assets/3.png",
                      //                                       fit: BoxFit.fill,
                      //                                       scale: 1,
                      //                                       errorBuilder: (context, error,
                      //                                           stackTrace) {
                      //                                         if (kDebugMode) {
                      //                                           print(error);
                      //                                         }
                      //                                         return const Icon(
                      //                                             Icons.info);
                      //                                       },
                      //                                     ),
                      //                             ),
                      //                             Center(
                      //                                 child: categories[index].id ==
                      //                                         selectedCat
                      //                                     ? Row(
                      //                                         mainAxisAlignment:
                      //                                             MainAxisAlignment
                      //                                                 .center,
                      //                                         children: [
                      //                                           Text(
                      //                                             categories[index]
                      //                                                 .nameAr,
                      //                                             style:
                      //                                                 GoogleFonts.cairo()
                      //                                                     .copyWith(
                      //                                               color: Colors.black,
                      //                                               fontSize: 13,
                      //                                               fontWeight:
                      //                                                   FontWeight.bold,
                      //                                             ),
                      //                                           ),
                      //                                         ],
                      //                                       )
                      //                                     : Column(
                      //                                         mainAxisAlignment:
                      //                                             MainAxisAlignment
                      //                                                 .center,
                      //                                         children: [
                      //                                           Text(
                      //                                             categories[index]
                      //                                                 .nameAr,
                      //                                             style:
                      //                                                 GoogleFonts.cairo()
                      //                                                     .copyWith(
                      //                                               fontSize: 13,
                      //                                               fontWeight:
                      //                                                   FontWeight.bold,
                      //                                               color: Colors
                      //                                                   .black87, // here
                      //                                             ),
                      //                                           ),
                      //                                         ],
                      //                                       )),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      // if (selectedCat != null)
                      //   Container(
                      //     height: 100,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         color: themeNotifier.isDark
                      //             ? Theme.of(context).primaryColor : Colors.white,
                      //         borderRadius: const BorderRadius.only(
                      //             topLeft: Radius.circular(10),
                      //             topRight: Radius.circular(10))),
                      //     padding: const EdgeInsets.all(5),
                      //     child: ListView.builder(
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.horizontal,
                      //       itemCount: categories
                      //           .firstWhere((el) => el.id == selectedCat)
                      //           .categoryOptions
                      //           ?.length,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return Material(
                      //           color: selectedCat == index && index != 2
                      //               ? Colors.black
                      //               : Colors.white,
                      //           child: GestureDetector(
                      //             onTap: () {
                      //               setState(() {
                      //                 catOption = categories
                      //                     .firstWhere(
                      //                         (el) => el.id == selectedCat)
                      //                     .categoryOptions![index]
                      //                     .id;
                      //                 currentPage = 1;
                      //               });
                      //               _initProductData = _initProducts();
                      //             },
                      //             child: Padding(
                      //               padding: const EdgeInsets.only(right: 15),
                      //               child: Container(
                      //                 height: 25,
                      //                 padding: const EdgeInsets.symmetric(
                      //                     horizontal: 20),
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(25),
                      //                   color: themeNotifier.isDark
                      //                       ? Colors.white
                      //                       : Theme.of(context)
                      //                           .primaryColor
                      //                           .withOpacity(categories
                      //                                       .firstWhere((el) =>
                      //                                           el.id ==
                      //                                           selectedCat)
                      //                                       .categoryOptions![
                      //                                           index]
                      //                                       .id ==
                      //                                   catOption
                      //                               ? 0.6
                      //                               : 0),
                      //                 ),
                      //                 child: Column(
                      //                   children: [
                      //                     SizedBox(
                      //                       width: 45,
                      //                       height: 45,
                      //                       child: categories
                      //                                   .firstWhere((el) =>
                      //                                       el.id ==
                      //                                       selectedCat)
                      //                                   .categoryOptions![index]
                      //                                   .photo !=
                      //                               null
                      //                           ? CachedNetworkImage(
                      //                               imageUrl:
                      //                                   "https://yoo2.smart-node.net${categories.firstWhere((el) => el.id == selectedCat).categoryOptions![index].photo}",
                      //                               progressIndicatorBuilder: (context,
                      //                                       url,
                      //                                       downloadProgress) =>
                      //                                   CircularProgressIndicator(
                      //                                       value:
                      //                                           downloadProgress
                      //                                               .progress),
                      //                               errorWidget:
                      //                                   (context, url, error) =>
                      //                                       Image.asset(
                      //                                 "assets/3.png",
                      //                                 fit: BoxFit.fill,
                      //                                 scale: 1,
                      //                                 errorBuilder: (context,
                      //                                     error, stackTrace) {
                      //                                   if (kDebugMode) {
                      //                                     print(error);
                      //                                   }
                      //                                   return const Icon(
                      //                                       Icons.info);
                      //                                 },
                      //                               ),
                      //                             )
                      //                           : Image.asset(
                      //                               "assets/3.png",
                      //                               fit: BoxFit.fill,
                      //                               scale: 1,
                      //                               errorBuilder: (context,
                      //                                   error, stackTrace) {
                      //                                 if (kDebugMode) {
                      //                                   print(error);
                      //                                 }
                      //                                 return const Icon(
                      //                                     Icons.info);
                      //                               },
                      //                             ),
                      //                     ),
                      //                     Center(
                      //                       child: categories
                      //                                   .firstWhere((el) =>
                      //                                       el.id ==
                      //                                       selectedCat)
                      //                                   .categoryOptions![index]
                      //                                   .id ==
                      //                               catOption
                      //                           ? Row(
                      //                               mainAxisAlignment:
                      //                                   MainAxisAlignment
                      //                                       .center,
                      //                               children: [
                      //                                 Text(
                      //                                   categories
                      //                                       .firstWhere((el) =>
                      //                                           el.id ==
                      //                                           selectedCat)
                      //                                       .categoryOptions![
                      //                                           index]
                      //                                       .categoryOption,
                      //                                   style:
                      //                                       GoogleFonts.cairo()
                      //                                           .copyWith(
                      //                                     fontSize: 13,
                      //                                     fontWeight:
                      //                                         FontWeight.bold,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             )
                      //                           : Column(
                      //                               mainAxisAlignment:
                      //                                   MainAxisAlignment
                      //                                       .center,
                      //                               children: [
                      //                                 Text(
                      //                                   categories
                      //                                       .firstWhere((el) =>
                      //                                           el.id ==
                      //                                           selectedCat)
                      //                                       .categoryOptions![
                      //                                           index]
                      //                                       .categoryOption,
                      //                                   style:
                      //                                       GoogleFonts.cairo()
                      //                                           .copyWith(
                      //                                     fontSize: 13,
                      //                                     fontWeight:
                      //                                         FontWeight.bold,
                      //                                     color: Colors.black87,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // if (_initProductData == null)
                      //   const BuildShimmer(
                      //     itemCount: 4,
                      //     crossItems: 2,
                      //   ),
                      // if (_initProductData != null)
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
                      // if (selectedCat != null)
                      //   Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       if (currentPage != pages)
                      //         ElevatedButton.icon(
                      //           onPressed: () async {
                      //             if (!loading) {
                      //               await loadProducts();
                      //             }
                      //           },
                      //           icon: loading
                      //               ? const Padding(
                      //                   padding: EdgeInsets.all(5.0),
                      //                   child: CircularProgressIndicator(
                      //                     color: Colors.white,
                      //                   ),
                      //                 )
                      //               : const Icon(Icons.grid_view_outlined),
                      //           label: loading
                      //               ? const Text('')
                      //               : Text(
                      //                   "عرض المزيد من ${categories.firstWhere((el) => el.id == selectedCat).nameAr}"),
                      //         ),
                      //     ],
                      //   )
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
