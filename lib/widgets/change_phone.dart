import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ChangePhoneWidget extends StatefulWidget {
  const ChangePhoneWidget({Key? key}) : super(key: key);
  @override
  State<ChangePhoneWidget> createState() => _ChangePhoneWidgetState();
}

class _ChangePhoneWidgetState extends State<ChangePhoneWidget> {
  bool loading = false;
  int step = 1;
  String? msg;
  late UserBloc user;
  OtpFieldController otpController = OtpFieldController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController tel = TextEditingController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      sendOtp();
    });
  }

  sendOtp() async {
    setState(() {
      loading = true;
      msg = null;
    });
    await user.getOtp(context);
    setState(() {
      step = 1;
      loading = false;
      msg = null;
    });
  }

  submit() async {
    setState(() {
      loading = true;
      msg = null;
    });
    try {
      Map<String, String> map = {};
      if (tel.text.isNotEmpty) {
        map['tel'] = tel.text;
      }
      final resp = await user.update(map, context);
      if (resp) {
        setState(() {
          loading = false;
          msg = null;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          loading = false;
          msg = 'حدث خطاَ ما';
          step = 2;
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
                  const SizedBox(
                    height: 5.0,
                  ),
                  if (step == 1 && loading)
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("تم الأن إرسال الرمز السري"),
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (step == 2 && loading)
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (step == 1 && !loading)
                   Center(
                      child: Text(
                        "تم إرسال الرمز السري",
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 22,
                        ),
                      ),
                    ),
                  if (step == 1 && !loading)
                    Center(
                      child: Text(
                        'ل${user.user?.tel}',
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 22,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  if (step == 1 && !loading)
                    const SizedBox(
                      height: 10.0,
                    ),
                  if (step == 1 && !loading)
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: OTPTextField(
                            controller: otpController,
                            length: 4,
                            width: MediaQuery.of(context).size.width,
                            textFieldAlignment: MainAxisAlignment.spaceEvenly,
                            fieldWidth: 45,
                            fieldStyle: FieldStyle.underline,
                            outlineBorderRadius: 8,
                            style: GoogleFonts.cairo().copyWith(fontSize: 17),
                            onCompleted: (pin) async {
                              setState(() {
                                loading = true;
                                msg = null;
                              });
                              final test = await user.validateOtp(pin, context);
                              if (test) {
                                setState(() {
                                  step = 2;
                                  loading = false;
                                  msg = null;
                                });
                              } else {
                                setState(() {
                                  step = 1;
                                  loading = false;
                                  msg = "الرمز الذي أدخلته خاطئ";
                                });
                              }
                            }),
                      ),
                    ),
                  if (step == 1 && !loading)
                    const SizedBox(
                      height: 15,
                    ),
                  if (step == 2 && !loading)
                    const SizedBox(
                      height: 15,
                    ),
                  if (step == 2 && !loading)
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: tel,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value == null ? "الرجاء إدخال رقم الهاتف" : null,
                      decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .8),
                        hintText: '0xxxxxxxxx',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        label: const Text("رقم الهاتف"),
                      ),
                    ),
                  if (msg != null)
                    Center(
                      child: Text(
                        '$msg',
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  if (step == 2 && !loading)
                    const SizedBox(
                      height: 15,
                    ),
                  if (step == 2 && !loading)
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
                  const SizedBox(
                    height: 25.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
