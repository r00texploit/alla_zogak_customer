import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../providers/cart_provider.dart';

class UpdateQtyWidget extends StatefulWidget {
  final Cart item;
  const UpdateQtyWidget({Key? key, required this.item}) : super(key: key);
  @override
  State<UpdateQtyWidget> createState() => _UpdateQtyWidgetState();
}

class _UpdateQtyWidgetState extends State<UpdateQtyWidget> {
  bool loading = false;
  late CartBloc cart;
  TextEditingController qty = TextEditingController();
  // late AddressBloc address;

  @override
  initState() {
    qty.text = widget.item.qty.toString();
    super.initState();
  }

  submit() async {
    setState(() {
      loading = true;
    });
    await cart.updateToQty(widget.item.id,int.parse(qty.text),context);
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // address = Provider.of<AddressBloc>(context);
    cart = Provider.of<CartBloc>(context);
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
        if (!loading)
          Form(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15,),
              constraints: const BoxConstraints(
                maxHeight: 120,
              ),
              child: TextFormField(
              controller: qty,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              autovalidateMode: AutovalidateMode.always,
              validator: (value) => value == null ? "الرجاء إدخال الكمية" : value == "0"? "الرجاء إدخال قيمة أعلي من صفر" : null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                label: Text("أدخل الكمية"),
              ),
            ),
            ),
          ),
        if (loading)
          const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  color: Colors.grey,
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
            onPressed: () => qty.text.isNotEmpty && qty.text != '0' ? submit() : null,
            icon: const Icon(Icons.add),
            label: const Text("تحديث الكمية"),
          ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
