import 'dart:developer';

import 'package:alla_zogak_customer/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:responsive_grid/responsive_grid.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int itemCount = 10;
  int? divison;

  @override
  Widget build(BuildContext context) {
    divison = itemCount % 5;

    return Scaffold(
      body: Center(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * .35,
            // child: ListView.separated(
            //   separatorBuilder: (_, __) => const SizedBox(width: 20),
            //   scrollDirection: Axis.horizontal,
            //   itemCount: itemCount ~/ divison!,
            //   itemBuilder: (context, index) {
            // child: GridView.builder(
            //   itemCount: 4,
            //   scrollDirection: Axis.horizontal,
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     // childAspectRatio: 90 / 256,
            //     crossAxisCount: 2,
            //   ),
            //   itemBuilder: (context, index) {
            //     return Column(
            //       children: [
            //         Text(divison!.toString()),
            //         Text(((itemCount ~/ divison!) * 0 + index).toString()),
            //         Text(((itemCount ~/ divison!) * 1 + index).toString()),
            //       ],
            //     );
            //   },
            // ),
            child: ResponsiveGridRow(children: [
              ResponsiveGridCol(
                lg: 12,
                child: Container(
                  height: 100,
                  alignment: Alignment(0, 0),
                  color: Colors.purple,
                  child: Text("lg : 12"),
                ),
              ),
              ResponsiveGridCol(
                xs: 6,
                md: 3,
                child: Container(
                  height: 100,
                  alignment: Alignment(0, 0),
                  color: Colors.green,
                  child: Text("xs : 6 \r\nmd : 3"),
                ),
              ),
              ResponsiveGridCol(
                xs: 6,
                md: 3,
                child: Container(
                  height: 100,
                  alignment: Alignment(0, 0),
                  color: Colors.orange,
                  child: Text("xs : 6 \r\nmd : 3"),
                ),
              ),
              ResponsiveGridCol(
                xs: 6,
                md: 3,
                child: Container(
                  height: 100,
                  alignment: Alignment(0, 0),
                  color: Colors.red,
                  child: Text("xs : 6 \r\nmd : 3"),
                ),
              ),
              ResponsiveGridCol(
                xs: 6,
                md: 3,
                child: Container(
                  height: 100,
                  alignment: Alignment(0, 0),
                  color: Colors.blue,
                  child: Text("xs : 6 \r\nmd : 3"),
                ),
              ),
            ])),
      ),
    );
  }
}
