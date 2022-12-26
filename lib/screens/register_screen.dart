import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../api/user.dart';
import '../models/response_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool loading = false;
  bool agree = false;
  int step = 1;
  int time = 30;
  String? errMsg;
  String? msg;
  OtpFieldController otpController = OtpFieldController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rePassword = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  register() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    try {
      ResponseModel resp = await registerCustomer(
          {'name': name.text, 'tel': phone.text, 'password': password.text});
      if (resp.success) {
        step = 2;
        runTimer();
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        loading = false;
      });
    }
  }

  runTimer() {
    Timer(const Duration(seconds: 1), () {
      if (time > 0 && mounted) {
        setState(() {
          time--;
        });
        runTimer();
      }
    });
  }

  resendOtp() async {
    await login({'tel': phone.text, 'password': password.text});
    setState(() {
      time = 30;
    });
    runTimer();
  }

  verifyMyUser(String otp) async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    try {
      ResponseModel resp =
          await verifyRegistrationOtp(otp, {"tel": phone.text});
      if (resp.success) {
        setState(() {
          loading = false;
        });
        final success = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color.fromARGB(255, 21, 143, 31),
          content: Text(
            'تم النسجيل بنجاح الآن يمكنك تسجل الدخول!',
            style: GoogleFonts.cairo().copyWith(color: Colors.white),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(success);
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, 'login');
        });
      } else {
        setState(() {
          loading = true;
          msg = "الرمز الذي ادخلته خاطي";
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        loading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل مستخدم جديد"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: loading
                      ? const Center(
                          child: SizedBox(
                            height: 45,
                            width: 45,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : step == 2
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/logo.png",
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "الرجاء إدخال رمز التحقق الذي تم ارساله إلي ${phone.text}",
                                    style: GoogleFonts.cairo().copyWith(
                                      fontSize: 24,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: OTPTextField(
                                        controller: otpController,
                                        length: 4,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        textFieldAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        fieldWidth: 45,
                                        hasError: msg != null,
                                        fieldStyle: FieldStyle.underline,
                                        outlineBorderRadius: 8,
                                        style: GoogleFonts.cairo()
                                            .copyWith(fontSize: 17),
                                        onCompleted: (pin) async =>
                                            await verifyMyUser(pin),
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 75,
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            if (time == 0) {
                                              resendOtp();
                                            }
                                          },
                                          child: Text(
                                            time == 0
                                                ? "إعادة الإرسال"
                                                : "$time ثواني",
                                            style: GoogleFonts.cairo().copyWith(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                if (msg != null)
                                  Text(
                                    "$msg",
                                    style: GoogleFonts.cairo().copyWith(
                                      color: Colors.red,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  const SizedBox(height: 10),
                                  Image.asset(
                                    "assets/logo.png",
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 38.0,
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .7,
                                      child: Form(
                                        key: _key,
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .7,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.name,
                                                controller: name,
                                                textInputAction:
                                                    TextInputAction.next,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) =>
                                                    value == null ||
                                                            value.isEmpty
                                                        ? "الرجاء إدخال الأسم"
                                                        : null,
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .8),
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  label: const Text("الأسم"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller: phone,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (value) => value ==
                                                        null
                                                    ? "الرجاء إدخال رقم الهاتف"
                                                    : value.length < 10
                                                        ? "رقم الهاتف مكون من 10 أرقام"
                                                        : null,
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .8),
                                                  hintText: '0xxxxxxxxx',
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  label:
                                                      const Text("رقم الهاتف"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: password,
                                                textInputAction:
                                                    TextInputAction.next,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                obscureText: true,
                                                validator: (value) => value ==
                                                        null
                                                    ? "الرجاء إدخال كلمة المرور"
                                                    : value.length < 6
                                                        ? 'يجب ان تكون كلمة المرور اكثر من 5 أحرف'
                                                        : null,
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .8),
                                                  hintText: 'xxxxxxxxx',
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  label:
                                                      const Text("كلمة المرور"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: rePassword,
                                                obscureText: true,
                                                textInputAction:
                                                    TextInputAction.done,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) => value ==
                                                            null ||
                                                        value.isEmpty
                                                    ? "الرجاء إدخال كلمة المرور"
                                                    : value != password.text
                                                        ? 'يجب ان تكون مطابقة لكلمة المرور'
                                                        : null,
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .8),
                                                  hintText: 'xxxxxxxxx',
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                  label: const Text(
                                                      "أعد كتابة كلمة المرور"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: agree,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        agree = value as bool;
                                                      });
                                                    },
                                                  ),
                                                  const Text(
                                                      "أوافق علي سياسة الخصوصيه"),
                                                ],
                                              ),
                                              if (errMsg != null && !agree)
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      errMsg!,
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  final valid = _key
                                                      .currentState
                                                      ?.validate();
                                                  if (valid != null &&
                                                      valid &&
                                                      agree) {
                                                    await register();
                                                  } else {
                                                    if (!agree) {
                                                      setState(() {
                                                        errMsg =
                                                            "يجب الموافقه علي سياسة الخصوصية";
                                                      });
                                                    }
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 10,
                                                    ),
                                                  ),
                                                ),
                                                icon: loading == true
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.white,
                                                      )
                                                    : const Icon(
                                                        Icons.person_add),
                                                label: loading == false
                                                    ? const Text("تسجيل")
                                                    : const Text(""),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
