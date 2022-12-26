import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuildShimmer extends StatelessWidget {
  final int itemCount;
  final int crossItems;
  const BuildShimmer(
      {Key? key, required this.itemCount, required this.crossItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return crossItems != 1
        ? Wrap(
            // padding: const EdgeInsets.all(20),
            // crossAxisCount: crossItems,
            // shrinkWrap: true,
            // childAspectRatio: 0.8,
            // physics: const BouncingScrollPhysics(),
            // mainAxisSpacing: 15,
            // crossAxisSpacing: 10,
            children: List.generate(
              itemCount,
              (index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 194, 194, 194),
                    highlightColor: Colors.grey[100]!,
                    child: SizedBox(
                      height: 120,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                    ),
                  ),
                );
              },
            ),
          )
        : Column(
            children: List.generate(itemCount, (index) {
              return Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 194, 194, 194),
                highlightColor: Colors.grey[100]!,
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: 100,
                      minHeight: 80,
                      maxWidth: MediaQuery.of(context).size.width,
                      minWidth: MediaQuery.of(context).size.width * 0.95),
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          height: 25,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 25,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 25,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
  }
}
