import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../api/orders.dart';
import '../models/response_model.dart';

import '../models/orders.dart';

class ReviewWidget extends StatefulWidget {
  final Orders item;
  final Future Function(double val, int id) status;
  const ReviewWidget({Key? key, required this.item, required this.status})
      : super(key: key);
  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  bool loading = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  double _rating = 1;
  TextEditingController review = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  submit() async {
    final valid = _key.currentState?.validate();
    if (valid == true) {
      setState(() {
        loading = true;
      });
      ResponseModel resp = await reviewOreder(widget.item.id,{"review": review.text,"stars": _rating});
      if (resp.success) {
        await widget.status(_rating, widget.item.id);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: Center(
                child: Row(
                  children: const [
                    Icon(
                      Icons.network_check,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("تأكد من إتصالك بالأنترنت"),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
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
              ),
              child: RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                unratedColor: Colors.amber.withAlpha(50),
                itemCount: 5,
                itemSize: 50.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                updateOnDrag: true,
              ),
            ),
          if (!loading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.text,
                minLines: 2,
                maxLines: 3,
                controller: review,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "أكتب تعليقك هنا",
                ),
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
              onPressed: () => submit(),
              icon: const Icon(Icons.reviews),
              label: const Text("تقييم"),
            ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
