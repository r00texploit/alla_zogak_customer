import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../providers/cart_provider.dart';

import '../widgets/select_address.dart';
import '../widgets/update_qty.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  late CartBloc cart;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await cart.loadData(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cart = Provider.of<CartBloc>(context);
    return Scaffold(
      body: cart.status == 200
          ? SafeArea(
              child: cart.cart.isEmpty && !cart.isLoading
                  ? cartEmpty(
                      context, 'العربة فارقة', "لا يوجد لديك منتجات في عربتك")
                  : Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: cart.cart.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListItem(
                                item: cart.cart[index],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 5.0, left: 20, right: 20),
                          child: Row(
                            children: <Widget>[
                              const Text(
                                'الإجمالي',
                              ),
                              const Spacer(),
                              Text("SDG " "${cart.cartTotal}"),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            height: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: !loading
                                  ? Text(
                                      "إنشاء طلب",
                                      style: GoogleFonts.cairo().copyWith(
                                        color: Colors.black,
                                      ),
                                    )
                                  : const CircularProgressIndicator(
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                              ),
                              backgroundColor: Colors.white,
                              builder: (context) => Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: const SelectAddressesWidget(),
                              ),
                            );
                          },
                        ),
                      ],
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
                      onPressed: () => cart.refresh(context),
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

noCartText(BuildContext context, String val) {
  return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Text(val,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: Colors.black, fontWeight: FontWeight.normal)));
}

noCartDec(BuildContext context, String val) {
  return Container(
    padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
    child: Text(val,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
            )),
  );
}

cartEmpty(BuildContext context, String val, String val2) {
  return Center(
    child: SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        noCartText(context, val),
        noCartDec(context, val2),
      ]),
    ),
  );
}

class ListItem extends StatefulWidget {
  final Cart item;
  const ListItem({Key? key, required this.item}) : super(key: key);
  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late CartBloc cart;
  bool loading = false;
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
        fit: BoxFit.fitWidth,
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cart = Provider.of<CartBloc>(context);
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          cart.inctanceRemove(widget.item.id, context);
        });
      },
      key: UniqueKey(),
      background: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Theme.of(context).primaryColor,
                spreadRadius: 2,
              )
            ]),
        alignment: AlignmentDirectional.centerEnd,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      child: Card(
        elevation: 0.4,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              if (widget.item.productOptionValues?.productImages != null)
                SizedBox(
                  height: 100,
                  width: 80,
                  child: Image.network(
                    'https://yoo2.smart-node.net${widget.item.productOptionValues?.productImages?.image}',
                    fit: BoxFit.fitHeight,
                  ),
                ),
              if (widget.item.productOptionValues?.productImages == null)
                SizedBox(
                  height: 115,
                  width: 80,
                  child: Image.asset(
                    "assets/3.png",
                    fit: BoxFit.fitHeight,
                    scale: 1,
                    key: GlobalKey(),
                    errorBuilder: (context, error, stackTrace) {
                      if (kDebugMode) {
                        print(error);
                      }
                      return const Icon(Icons.camera_alt);
                    },
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.item.products?.name}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Row(
                              children: [
                                if (widget.item.productOptionValues
                                        ?.productColors !=
                                    null)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    color: Color.fromRGBO(
                                      widget.item.productOptionValues!
                                          .productColors!.r,
                                      widget.item.productOptionValues!
                                          .productColors!.g,
                                      widget.item.productOptionValues!
                                          .productColors!.b,
                                      1,
                                    ),
                                  ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (widget.item.productOptionValues
                                        ?.categoryOpitionValues !=
                                    null)
                                  Text(
                                    '${widget.item.productOptionValues?.categoryOpitionValues?.value}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                              ],
                            ),
                            if (widget.item.products?.vendors != null)
                              Text(
                                '${widget.item.products?.vendors?.name}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          if (!loading)
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsetsDirectional.only(
                                        end: 8, top: 8, bottom: 8),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 22,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    if (widget.item.qty != 1) {
                                      await cart.updateToQty(widget.item.id,
                                          widget.item.qty - 1, context);
                                    } else {
                                      await cart.inctanceRemove(
                                          widget.item.id, context);
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)),
                                    ),
                                    backgroundColor: Colors.white,
                                    builder: (context) => Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: UpdateQtyWidget(
                                        item: widget.item,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.item.qty.toString() == 'null'
                                            ? 1.toString()
                                            : widget.item.qty.toString(),
                                        style: GoogleFonts.cairo().copyWith(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.add,
                                      size: 22,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    await cart.updateToQty(widget.item.id,
                                        widget.item.qty + 1, context);
                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          if (loading)
                            const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            ),
                          const Spacer(),
                          Text(
                            'SDG ${widget.item.products != null ? widget.item.products!.price * double.parse(widget.item.qty.toString()) : ''}',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
