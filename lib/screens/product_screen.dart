import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../models/product_colors.dart';
import '../models/products.dart';
import '../screens/cart.dart';

import '../models/product_option_values.dart';
import '../providers/cart_provider.dart';

class ProductSc extends StatefulWidget {
  final Products product;
  const ProductSc({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductSc> createState() => _ProductScState();
}

class _ProductScState extends State<ProductSc> with TickerProviderStateMixin {
  final CarouselController _controller = CarouselController();
  late AnimationController _animationController;
  bool loading = false;
  late CartBloc cart;
  int colorIndex = 0;
  int valueIndex = 0;
  bool colorized = false;
  List<ProductColors> colors = [];
  List<ProductOptionValues> values = [];

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.addListener(() {
      setState(() {});
    });
    if (widget.product.productOptions![0].productOptionValues != null) {
      for (var i = 0;
          i < widget.product.productOptions![0].productOptionValues!.length;
          i++) {
        if (widget.product.productOptions![0].productOptionValues![i]
                .productColors !=
            null) {
          colorized = true;
          colors.add(widget.product.productOptions![0].productOptionValues![i]
              .productColors as ProductColors);
        }
      }
      if (colorized) {
        values.addAll(widget.product.productOptions![0].productOptionValues!
            .where((e) =>
                e.productColorId == colors[0].id &&
                e.categoryOpitionValues != null)
            .toList());
      } else {
        values.addAll(
            widget.product.productOptions![0].productOptionValues!.toList());
      }
    }
    super.initState();
  }

  changeColor(int i) {
    values.clear();
    setState(() {
      List<ProductOptionValues>? productOptionValues = widget
          .product.productOptions![0].productOptionValues
          ?.where((el) => el.productColorId == colors[colorIndex].id)
          .toList();
      if (productOptionValues != null && productOptionValues.isNotEmpty) {
        if (widget.product.productImages != null &&
            widget.product.productImages!.isNotEmpty) {
          int imgIndex = widget.product.productImages!.indexWhere(
              (el) => el.id == productOptionValues[0].productImageId);
          if (imgIndex != -1) {
            _controller.jumpToPage(imgIndex);
          }
        }
      }
      colorIndex = i;
      values.addAll(widget.product.productOptions![0].productOptionValues!
          .where((e) =>
              e.productColorId == colors[colorIndex].id &&
              e.categoryOpitionValues != null)
          .toList());
      valueIndex = 0;
    });
  }

  changeValue(int i) {
    setState(() {
      valueIndex = i;
    });
  }

  animate() {
    if (_animationController.isDismissed) {
      _animationController.forward(from: 60);
    } else {
      _animationController.reverse(from: 250);
    }
  }

  addOrRemove() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
      if (cart.verify(widget.product.id)) {
        await cart.remove(widget.product.id, context);
      } else {
        await cart.add({
          "product_id": widget.product.id,
          "category_option_value_id": values[valueIndex].value,
          "product_option_value_id": values[valueIndex].id,
          "qty": 1
        }, context);
      }
      setState(() {
        loading = false;
      });
    }
  }

  bool get verifyQty {
    bool verified = false;
    int? valIn;
    int? colIn;
    if (values.isNotEmpty) {
      valIn = values[valueIndex].id;
    }
    if (colors.isNotEmpty) {
      colIn = colors[colorIndex].id;
    }
    if (widget.product.productOptions![0].productOptionValues != null) {
      ProductOptionValues? productOV =
          widget.product.productOptions![0].productOptionValues?.firstWhere(
        (el) => el.productColorId == colIn || el.value == valIn,
        orElse: () {
          return ProductOptionValues(
            id: 0,
            productOptionId: 1,
            productImageId: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            qty: 0,
          );
        },
      );
      if (productOV != null) {
        if (productOV.qty != 0) {
          verified = true;
        }
      }
    }
    return verified;
  }

  @override
  void dispose() {
    _animationController.removeListener(() {});
    cart.removeListener(() {});
    super.dispose();
  }

  Widget _buildProductOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //if (colorized && colors.isNotEmpty)
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     verticalDirection: VerticalDirection.up,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: List.generate(colors.length, (i) {
            //       return GestureDetector(
            //         onTap: () => changeColor(i),
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(10.0),
            //           child: Container(
            //             width: 35,
            //             height: 35,
            //             decoration: BoxDecoration(
                          
            //               color: Color.fromRGBO(
            //                   colors[i].r, colors[i].g, colors[i].b, 1),
            //               border: Border.all(
            //                 color: Theme.of(context).primaryColor,
            //               ),
            //               borderRadius: BorderRadius.circular(50),
            //             ),
            //             margin: const EdgeInsets.symmetric(horizontal: 5),
            //             child: Padding(
            //               padding: const EdgeInsets.all(5.0),
            //               child: Stack(
            //                 children: [
            //                   if (colorIndex == i)
            //                     Positioned(
            //                       child: Container(
            //                         width: 15,
            //                         height: 15,
            //                         color: Theme.of(context).primaryColor,
            //                         child: const Icon(
            //                           Icons.done,
            //                           size: 15,
            //                         ),
            //                       ),
            //                     ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            //   ),
            // ),
          // const SizedBox(
          //   height: 15,
          // ),
          if (values.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                verticalDirection: VerticalDirection.up,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(values.length, (i) {
                  return GestureDetector(
                    onTap: () => changeValue(i),
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 40,
                      ),
                      decoration: BoxDecoration(
                        color: valueIndex == i
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(
                            "${values[i].categoryOpitionValues?.value}",
                            style: GoogleFonts.cairo().copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsDisplay(Products productss, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        productss.name,
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: _buildProductOptions(context),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "وصف المنتج",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        productss.description,
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    cart = Provider.of<CartBloc>(context);
    cart.verify(widget.product.id);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyCart()));
            },
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
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
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
          ),
        ],
        title: Text(
          widget.product.name,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                if (widget.product.productImages != null &&
                    widget.product.productImages!.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Hero(
                        tag: 'product_image_${widget.product.id}',
                        child: Stack(
                          children: [
                            CarouselSlider.builder(
                              itemBuilder: (context, i, realIndex) {
                                return Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://yoo2.smart-node.net${widget.product.productImages![i].image}",
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
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
                                    ),
                                    // Image(
                                    //   image: PCacheImage(
                                    //       "https://yoo2.smart-node.net${widget.product.productImages![i].image}",
                                    //       enableCache: true,
                                    //       enableInMemory: true),
                                    //   fit: BoxFit.fill,
                                    // ),
                                  ),
                                );
                              },
                              itemCount: widget.product.productImages!.length,
                              carouselController: _controller,
                              options: CarouselOptions(
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.scale,
                                enlargeCenterPage: true,
                                pauseAutoPlayOnManualNavigate: false,
                                autoPlay: false,
                              ),
                            ),
                            Positioned(
                              top: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder()),
                                    ),
                                    onPressed: () => _controller.previousPage(),
                                    child: const Icon(Icons.arrow_back),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder()),
                                    ),
                                    onPressed: () => _controller.nextPage(),
                                    child: const Icon(Icons.arrow_forward),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.product.productImages!.length,
                    (i) => Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      child: GestureDetector(
                        onTap: () => _controller.animateToPage(i),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://yoo2.smart-node.net${widget.product.productImages![i].image}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Image.asset(
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
                        // )
                      ),
                    ),
                  ),
                ),
                _buildProductDetailsDisplay(widget.product, context),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text:
                              '${widget.product.discount != null ? (widget.product.price / (widget.product.discount! * 0.1)).ceil() : widget.product.price}',
                          style: GoogleFonts.cairo().copyWith(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: ' جنيه',
                              style: GoogleFonts.cairo().copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.product.discount != null)
                        RichText(
                          text: TextSpan(
                            text: '${widget.product.price}',
                            style: GoogleFonts.cairo().copyWith(
                              fontSize: 14,
                              color: Colors.redAccent,
                              decoration: TextDecoration.lineThrough,
                            ),
                            children: [
                              TextSpan(
                                text: ' جنيه',
                                style: GoogleFonts.cairo().copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => verifyQty ? addOrRemove() : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        color: loading
                            ? Colors.white
                            : cart.verify(widget.product.id)
                                ? Colors.redAccent.withOpacity(0.6)
                                : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: !loading
                            ? verifyQty
                                ? Text(
                                    cart.verify(widget.product.id)
                                        ? "إزالة المنتج من السلة"
                                        : "أضف الي السلة",
                                    style: GoogleFonts.cairo().copyWith(
                                      fontSize: 18,
                                    ),
                                  )
                                : Text(
                                    "منتهي",
                                    style: GoogleFonts.cairo().copyWith(
                                      fontSize: 18,
                                    ),
                                  )
                            : const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
