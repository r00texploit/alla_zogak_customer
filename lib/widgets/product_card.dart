import 'package:alla_zogak_customer/screens/product_screen.dart';
import 'package:alla_zogak_customer/widgets/theme/theme_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String image;

  const Product(
      {required this.id,
      required this.image,
      required this.price,
      required this.title});
}

class ProductCard extends StatefulWidget {
  final Products product;
  final bool hero;

  const ProductCard({Key? key, required this.product, this.hero = false})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late CartBloc cart;
  bool loading = false;
  bool loadingWish = false;
  late WishlistBloc wishlist;
  Widget prepareImage(String uri) {
    try {
      return CachedNetworkImage(
        imageUrl: uri,

        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Image.asset(
          "assets/3.png",
          fit: BoxFit.fill,
          scale: 1,
          key: GlobalKey(),
          errorBuilder: (context, error, stackTrace) {
            if (kDebugMode) {
              print(error);
            }
            return const Icon(Icons.info);
          },
        ),
        fit: BoxFit.cover,
        // :,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Image.asset(
        "assets/3.png",
        fit: BoxFit.fill,
        scale: 1,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.info),
      );
    }
  }

  @override
  void initState() {
    super.initState();
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
          "category_option_value_id": widget
                  .product.productOptions![0].productOptionValues!.isNotEmpty
              ? widget.product.productOptions![0].productOptionValues![0].value
              : null,
          "product_option_value_id":
              widget.product.productOptions![0].productOptionValues![0].id,
          "qty": 1
        }, context);
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    cart.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cart = Provider.of<CartBloc>(context);
    wishlist = Provider.of<WishlistBloc>(context);
    cart.verify(widget.product.id);
    var mq = MediaQuery.of(context).size;
    // var brightness = MediaQuery.of(context).platformBrightness;
    ThemeModel themeNotifier = ThemeModel();
    return Container(
      width: mq.width,
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeNotifier.isDark ? Colors.grey : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductSc(product: widget.product)));
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: Stack(
                    children: [
                      if (widget.hero)
                        Hero(
                          tag: 'product_image_${widget.product.id}',
                          child: widget.product.productImages != null &&
                                  widget.product.productImages!.isNotEmpty &&
                                  widget.product.productImages?.first.image !=
                                      null
                              ? prepareImage(
                                  "https://yoo2.smart-node.net${widget.product.productImages![0].image}")
                              : Image.asset(
                                  "assets/3.png",
                                  fit: BoxFit.fill,
                                  scale: 1,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.info),
                                ),
                        ),
                      if (!widget.hero)
                        widget.product.productImages != null &&
                                widget.product.productImages!.isNotEmpty &&
                                widget.product.productImages?.first.image !=
                                    null
                            ? prepareImage(
                                "https://yoo2.smart-node.net${widget.product.productImages![0].image}")
                            : Image.asset(
                                "assets/3.png",
                                fit: BoxFit.fill,
                                scale: 1,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.info),
                              ),
                    ],
                  ),
                ),
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${widget.product.discount != null ? (widget.product.price / (widget.product.discount! * 0.1)).ceil() : widget.product.price} ج.س",
                              style: GoogleFonts.cairo().copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            if (widget.product.discount != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${widget.product.discount}%",
                                    style: GoogleFonts.cairo().copyWith(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "${widget.product.price} ج.س",
                                    style: GoogleFonts.cairo().copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                      fontSize: 11,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            // Center(
                            //   child:

                            // ),
                          ],
                        ),
                        if (widget.product.productOptions != null &&
                            widget.product.productOptions!.isNotEmpty &&
                            widget.product.productOptions![0]
                                    .productOptionValues?.length !=
                                null &&
                            widget.product.productOptions![0]
                                .productOptionValues!.isNotEmpty)
                          GestureDetector(
                            onTap: () => addOrRemove(),
                            child: Container(
                              width: 33,
                              height: 33,
                              decoration: BoxDecoration(
                                  color: loading ? Colors.white : Colors.grey,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: !loading
                                    ? Icon(
                                        cart.verify(widget.product.id)
                                            ? Icons.remove_shopping_cart
                                            : Icons.add_shopping_cart,
                                        size: 22,
                                        color: Colors.white,
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
            if (widget.product.discount != null)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.red),
                  //   // borderRadius: BorderRadius.circular(50),
                  //   color: Theme.of(context).primaryColor,
                  // ),
                  // child: Center(
                  //   child: Text(
                  //     "${widget.product.discount}%",
                  //     style: GoogleFonts.cairo().copyWith(
                  //       color: Colors.red,
                  //       fontSize: 12,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //     overflow: TextOverflow.fade,
                  //     maxLines: 1,
                  //   ),
                  // ),
                ),
              ),
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: InkWell(
            //     onTap: () async {
            //       setState(() {
            //         loadingWish = true;
            //       });
            //       if (wishlist.verify(widget.product.id)) {
            //         await wishlist.remove(widget.product.id, context);
            //       } else {
            //         await wishlist.add(widget.product, context);
            //       }
            //       if (mounted) {
            //         setState(() {
            //           loadingWish = false;
            //         });
            //       }
            //     },
            //     child: Container(
            //       width: 45,
            //       height: 45,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(50),
            //       ),
            //       child: Center(
            //         child: !loadingWish
            //             ? Icon(
            //                 wishlist.verify(widget.product.id)
            //                     ? Icons.favorite
            //                     : Icons.favorite_border_sharp,
            //                 color: Colors.grey,
            //                 size: 20, // fav size is here
            //               )
            //             : const SizedBox(
            //                 width: 35,
            //                 height: 35,
            //                 child: CircularProgressIndicator(),
            //               ),
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              top: 0,
              // bottom: 0,
              left: 110,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    loadingWish = true;
                  });
                  if (wishlist.verify(widget.product.id)) {
                    await wishlist.remove(widget.product.id, context);
                  } else {
                    await wishlist.add(widget.product, context);
                  }
                  if (mounted) {
                    setState(() {
                      loadingWish = false;
                    });
                  }
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: !loadingWish
                        ? Icon(
                            wishlist.verify(widget.product.id)
                                ? Icons.favorite
                                : Icons.favorite_border_sharp,
                            color: Colors.grey,
                            size: 20, // fav size is here
                          )
                        : const SizedBox(
                            width: 35,
                            height: 35,
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SecondPageRoute extends CupertinoPageRoute {
//   final Products product;
//   SecondPageRoute(this.product)
//       : super(
//           builder: (BuildContext context) => ProductSc(
//             product: product,
//           ),
//         );

//   // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return FadeTransition(
//       opacity: animation,
//       child: ProductSc(
//         product: product,
//       ),
//     );
//   }
// }
