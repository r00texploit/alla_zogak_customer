import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);
  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  bool loading = false;
  late UserBloc user;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController reType = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  submit() async {
    setState(() {
      loading = true;
    });
    try {
      Map<String, String> map = {};
      if (password.text.isNotEmpty) {
        map['password'] = password.text;
        map['new_password'] = reType.text;
      }
      final resp = await user.newPassword(map, context);
      if (resp) {
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          loading = false;
        });
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
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: password,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value == null ? "الرجاء إدخال كلمة المرور" : null,
                    decoration: const InputDecoration(
                      label: Text("كلمة المرور الحاليه"),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: reType,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value == null
                        ? "الرجاء إدخال كلمة المرور"
                        : value.length < 6
                            ? "يجب أن يكون كلمة المرور أكثر من 5 أحرف"
                            : null,
                    decoration: const InputDecoration(
                      label: Text("كلمة المرور الجديده"),
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
                    onPressed: () {
                      final valid = _key.currentState?.validate();
                      if (!loading && valid == true) {
                        submit();
                      }
                    },
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
