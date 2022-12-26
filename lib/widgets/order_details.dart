import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sub_orders.dart';
import '../models/orders.dart';

class OrderDetailsWidget extends StatefulWidget {
  final Orders item;
  const OrderDetailsWidget({Key? key, required this.item}) : super(key: key);
  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  bool loading = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            height: 5,
            width: MediaQuery.of(context).size.width * .6,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        if (!loading)
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
              minHeight: MediaQuery.of(context).size.height * 0.2,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: widget.item.subOrders?.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                  ),
                  child: showSubOrder(widget.item.subOrders![i]),
                );
              },
            ),
          ),
        if (loading)
          Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
          ),
        if (!loading)
          ElevatedButton.icon(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text("رجوع"),
          ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget showSubOrder(SubOrders sub) {
    return Card(
      child: Column(
        children: [
          if (sub.vendors != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${sub.vendors?.name}",
                  style: GoogleFonts.cairo().copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ...getItems(sub),
        ],
      ),
    );
  }

  List<Widget> getItems(SubOrders list) {
    List<Widget> li = [];
    if (list.subOrderProducts != null) {
      for (var prod in list.subOrderProducts!) {
        if (prod.products != null) {
          li.add(
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SDG " + (prod.products!.price * prod.qty!.toInt()).toString(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.description_outlined,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                    Text(prod.products!.name + " (${prod.qty})"),
                    if (prod.productOptionValues != null &&
                        prod.productOptionValues?.categoryOpitionValues != null)
                      Text(
                          " ${prod.productOptionValues?.categoryOpitionValues?.value} "),
                    if (prod.productOptionValues == null ||
                        prod.productOptionValues?.categoryOpitionValues == null)
                      const Text(''),
                    if (prod.productOptionValues != null &&
                        prod.productOptionValues?.productColors != null)
                      Container(
                        height: 20,
                        width: 20,
                        color: Color.fromRGBO(
                            prod.productOptionValues!.productColors!.r,
                            prod.productOptionValues!.productColors!.g,
                            prod.productOptionValues!.productColors!.b,
                            1),
                      ),
                    if (prod.productOptionValues == null ||
                        prod.productOptionValues?.productColors == null)
                      const Text(''),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
    return li;
  }
}
