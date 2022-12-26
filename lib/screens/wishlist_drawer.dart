import 'package:alla_zogak_customer/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer.dart';

class WishlistDrawer extends StatefulWidget {
  const WishlistDrawer({Key? key}) : super(key: key);

  @override
  _WishlistDrawerState createState() => _WishlistDrawerState();
}

class _WishlistDrawerState extends State<WishlistDrawer> {
  late WishlistBloc wishlist;
  int limit = 10;
  int currentPage = 1;
  int pages = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        loading = true;
      });
      int total = await wishlist.loadData(context);
      if (mounted) {
        setState(() {
          loading = false;
          pages = (total / 10).ceil();
        });
      }
    });
  }

  Future<void> doRefresh() async {
    await wishlist.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    wishlist = Provider.of<WishlistBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("قائمة الرقبات"),
      ),
      body: wishlist.products.isEmpty && loading
          ? const BuildShimmer(
              itemCount: 4,
              crossItems: 2,
            )
          : wishlist.products.isEmpty && !loading
              ? RefreshIndicator(
                  onRefresh: doRefresh,
                  child: const Center(
                    child: Text("ليس هنالك منتجات في المفضله"),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: doRefresh,
                  child: GridView.count(
                    padding: const EdgeInsets.all(20),
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 0.8,
                    physics: const BouncingScrollPhysics(),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    children: List.generate(
                      wishlist.products.length,
                      (i) {
                        return ProductCard(
                          product: wishlist.products[i],
                          hero: false,
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
