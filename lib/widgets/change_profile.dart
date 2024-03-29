import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ChangeProfileWidget extends StatefulWidget {
  const ChangeProfileWidget({Key? key}) : super(key: key);
  @override
  State<ChangeProfileWidget> createState() => _ChangeProfileWidgetState();
}

class _ChangeProfileWidgetState extends State<ChangeProfileWidget> {
  bool loading = false;
  late UserBloc user;
  TextEditingController name = TextEditingController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      name.text = user.user?.name ?? "";
    });
  }

  submit() async {
    setState(() {
      loading = true;
    });
    try {
      Map<String, String> map = {};
      if (name.text.isNotEmpty) {
        map['name'] = name.text;
      }
      final resp = await user.update(map, context);
      if (resp) {
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      if (e is DioError) {
        if (kDebugMode) {
          print(e.message);
        }
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserBloc>(context);
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
        Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: name,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      label: Text("أسم المستخدم"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
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
                    onPressed: () => loading ? {} : submit(),
                    icon: loading
                        ? const Padding(
                            padding: EdgeInsets.all(3.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label:
                        loading ? const Text("") : const Text("حفظ التغيرات"),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
