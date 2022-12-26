import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/orders.dart';
import '../widgets/order_details.dart';
import '../widgets/review.dart';

import '../api/orders.dart';
import '../models/response_model.dart';
import '../models/sub_orders.dart';
import '../widgets/shimmer.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: SizedBox(
                          child: Text(
                            "الطلبات الحالية",
                            style: GoogleFonts.cairo().copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Text("الطلبات السابقة",
                            style: GoogleFonts.cairo().copyWith(
                              fontSize: 18,
                            )),
                      )
                    ],
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                    ),
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.black54,
                  ),
                ),
                const Expanded(
                  child: TabBarView(children: [
                    OnGoing(),
                    PastOrder(),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}

class OnGoing extends StatefulWidget {
  const OnGoing({Key? key}) : super(key: key);

  @override
  _OnGoingState createState() => _OnGoingState();
}

class _OnGoingState extends State<OnGoing> {
  int limit = 10;
  int currentPage = 1;
  int pages = 0;
  bool loading = false;
  List<Orders> _orderList = [];
  late Future<void> _initOrdersData;

  @override
  void initState() {
    _initOrdersData = _initOrders();
    super.initState();
  }

  Future<void> _initOrders() async {
    try {
      ResponseModel list =
          await getMyCurrentOrders(limit, (limit * (currentPage - 1)));
      _orderList = [];
      if (list.total != null) {
        pages = (list.total! / limit).ceil();
      }
      for (var i = 0; i < list.data.length; i++) {
        setState(() {
          _orderList.add(Orders.fromJson(list.data[i]));
        });
      }
    } catch (e, s) {
      if (kDebugMode) {
        print([e, s]);
      }
    }
  }

  Future<void> loadOrders() async {
    setState(() {
      loading = true;
    });
    currentPage++;
    try {
      ResponseModel list =
          await getMyCurrentOrders(limit, (limit * (currentPage - 1)));
      for (var i = 0; i < list.data.length; i++) {
        setState(() {
          _orderList.add(Orders.fromJson(list.data[i]));
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        currentPage = 1;
        _initOrdersData = _initOrders();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: _initOrdersData,
                builder: (context, snap) {
                  switch (snap.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: BuildShimmer(
                            itemCount: 4,
                            crossItems: 1,
                          ),
                        );
                      }
                    case ConnectionState.done:
                      {
                        if (_orderList.isEmpty) {
                          return const Center(
                            child: Text("ليس هنالك طلبات"),
                          );
                        } else {
                          return Column(
                            children: List.generate(_orderList.length,
                                (i) => listItem(_orderList[i])),
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
                        await loadOrders();
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
                    label: loading ? const Text('') : const Text("عرض المزيد"),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showDetails(Orders item) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: OrderDetailsWidget(
          item: item,
        ),
      ),
    );
  }

  Widget listItem(Orders item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEE, dd MMM, yyyy', 'ar-sa')
                      .format(item.createdAt),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black),
                ),
                Text(
                  "SDG " + getTotalPrice(item.subOrders!).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.black54),
                ),
              ],
            ),
            Text("الطلب رقم #" + item.id.toString()),
            ...getItems(item.subOrders!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularPercentIndicator(
                        radius: 20.0,
                        lineWidth: 5.0,
                        percent: readyPerc(item.subOrders!),
                        center: Text(
                          "${(readyPerc(item.subOrders!) * 100).ceil()}%",
                          style: GoogleFonts.cairo().copyWith(
                            fontSize: 10,
                          ),
                        ),
                        progressColor: readyPerc(item.subOrders!) < 1
                            ? Theme.of(context).primaryColor
                            : Colors.green,
                      ),
                    ),
                    Text(
                      "الجاهزية",
                      style: GoogleFonts.cairo().copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                if ((readyPerc(item.subOrders!) * 100).ceil() != 100)
                  Row(
                    children: [
                      Text(
                        "قيد التنفيذ",
                        style: GoogleFonts.cairo().copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.flash_on,
                          size: 22,
                          color: Color.fromARGB(255, 255, 230, 0),
                        ),
                      ),
                    ],
                  ),
                if ((readyPerc(item.subOrders!) * 100).ceil() == 100)
                  Row(
                    children: [
                      Text(
                        "قيد التوصيل",
                        style: GoogleFonts.cairo().copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.delivery_dining,
                          size: 22,
                          color: Color.fromARGB(255, 0, 68, 255),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text(
                    'تفاصيل الطلب',
                    style: GoogleFonts.cairo().copyWith(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () => showDetails(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double readyPerc(List<SubOrders> list) {
    int total = 0;
    int ready = 0;
    for (var el in list) {
      total += 1;
      if (el.readyTime != null) {
        ready += 1;
      }
    }
    return (ready * 100 / total) * 0.01;
  }

  int getTotalPrice(List<SubOrders> list) {
    int total = 0;
    for (var el in list) {
      if (el.subOrderProducts != null) {
        for (var prod in el.subOrderProducts!) {
          total += (prod.price * prod.qty!);
        }
      }
    }
    return total;
  }

  List<Widget> getItems(List<SubOrders> list) {
    List<Widget> li = [];
    for (var el in list) {
      if (el.subOrderProducts != null) {
        for (var prod in el.subOrderProducts!) {
          if (prod.products != null) {
            li.add(
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.description_outlined,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Text(prod.products!.name + " (${prod.qty})"),
                  )
                ],
              ),
            );
          }
        }
      }
    }
    return li;
  }
}

class PastOrder extends StatefulWidget {
  const PastOrder({Key? key}) : super(key: key);

  @override
  _PastOrderState createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  int limit = 10;
  int currentPage = 1;
  int pages = 0;
  bool loading = false;
  List<Orders> _orderList = [];
  late Future<void> _initOrdersData;

  @override
  void initState() {
    _initOrdersData = _initOrders();
    super.initState();
  }

  Future<void> _initOrders() async {
    try {
      ResponseModel list =
          await getMyPreviousOrders(limit, (limit * (currentPage - 1)));
      _orderList = [];
      if (list.total != null) {
        pages = (list.total! / limit).ceil();
      }
      for (var i = 0; i < list.data.length; i++) {
        setState(() {
          _orderList.add(Orders.fromJson(list.data[i]));
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> loadOrders() async {
    setState(() {
      loading = true;
    });
    currentPage++;
    try {
      ResponseModel list =
          await getMyPreviousOrders(limit, (limit * (currentPage - 1)));
      for (var i = 0; i < list.data.length; i++) {
        setState(() {
          _orderList.add(Orders.fromJson(list.data[i]));
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
              future: _initOrdersData,
              builder: (context, snap) {
                switch (snap.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: BuildShimmer(
                          itemCount: 4,
                          crossItems: 1,
                        ),
                      );
                    }
                  case ConnectionState.done:
                    {
                      if (_orderList.isEmpty) {
                        return const Center(
                          child: Text("ليس هنالك طلبات"),
                        );
                      } else {
                        return Column(
                          children: List.generate(_orderList.length,
                              (i) => listItem(_orderList[i])),
                        );
                      }
                    }
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentPage != pages && pages != 0)
                ElevatedButton.icon(
                  onPressed: () async {
                    if (!loading) {
                      await loadOrders();
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
                  label: loading ? const Text('') : const Text("عرض المزيد"),
                ),
            ],
          )
        ],
      ),
    );
  }

  Future reviewResponse(double rating, int id) async {
    int index = _orderList.indexWhere((el) => el.id == id);
    if (index != -1) {
      setState(() {
        _orderList[index].stars = rating.ceil();
      });
    }
  }

  review(Orders item) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ReviewWidget(
          item: item,
          status: reviewResponse,
        ),
      ),
    );
  }

  Widget listItem(Orders item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEE, dd MMM, yyyy', 'ar-sa')
                      .format(item.createdAt),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black),
                ),
                Text(
                  getTotalPrice(item.subOrders!).toString() + " ج.س",
                ),
              ],
            ),
            Text("الطلب رقم #" + item.id.toString()),
            ...getItems(item.subOrders!),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "تم التسليم",
                  style: GoogleFonts.cairo().copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (item.stars == null)
                  TextButton(
                    child: Text(
                      'تقييم',
                      style: GoogleFonts.cairo().copyWith(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => review(item),
                  ),
                if (item.stars != null)
                  RatingBarIndicator(
                    rating: item.stars!.toDouble(),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 25.0,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction: Axis.horizontal,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int getTotalPrice(List<SubOrders> list) {
    int total = 0;
    for (var el in list) {
      if (el.subOrderProducts != null) {
        for (var prod in el.subOrderProducts!) {
          if (prod.products != null) {
            total += prod.price;
          }
        }
      }
    }
    return total;
  }

  List<Widget> getItems(List<SubOrders> list) {
    List<Widget> li = [];
    for (var el in list) {
      if (el.subOrderProducts != null) {
        for (var prod in el.subOrderProducts!) {
          if (prod.products != null) {
            li.add(
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.description_outlined,
                      size: 15,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Text(prod.products!.name + " (${prod.qty})"),
                  )
                ],
              ),
            );
          }
        }
      }
    }
    return li;
  }
}
