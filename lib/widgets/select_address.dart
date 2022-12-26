import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class SelectAddressesWidget extends StatefulWidget {
  const SelectAddressesWidget({Key? key}) : super(key: key);
  @override
  State<SelectAddressesWidget> createState() => _SelectAddressesWidgetState();
}

class _SelectAddressesWidgetState extends State<SelectAddressesWidget> {
  bool loading = false;
  late CartBloc cart;
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  // late AddressBloc address;

  @override
  initState() {
    city.text = "الخرطوم";
    super.initState();
  }

  submit() async {
    setState(() {
      loading = true;
    });
    await cart.placeOrder({"address": address.text});
    setState(() {
      loading = false;
    });
    Navigator.pushNamed(context, "home");
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
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 15,
              ),
              constraints: const BoxConstraints(
                maxHeight: 220,
              ),
              child: Column(
                children: [
                  InputDecorator(
                    decoration: InputDecoration(
                      errorStyle: GoogleFonts.cairo()
                          .copyWith(color: Colors.redAccent, fontSize: 16.0),
                      // hintText: 'Please selec',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    isEmpty: city.text.isEmpty,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: city.text,
                        // isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            city.text = newValue.toString();
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: "الخرطوم",
                            child: Text("الخرطوم"),
                          ),
                          DropdownMenuItem<String>(
                            value: "بحري",
                            child: Text("بحري"),
                          ),
                          DropdownMenuItem<String>(
                            value: "أمدرمان",
                            child: Text("أمدرمان"),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: address,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) =>
                        value == null ? "الرجاء إدخال عنوان" : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      label: Text("أدخل عنوان"),
                    ),
                  ),
                ],
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
            onPressed: () => address.text.isNotEmpty ? submit() : null,
            icon: const Icon(Icons.add),
            label: const Text("طلب"),
          ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
