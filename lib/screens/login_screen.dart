import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/user.dart';
import '../models/response_model.dart';
import '../screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  bool otpRequired = false;
  String? token;
  String? msg;
  OtpFieldController otpController = OtpFieldController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  loginIntoApp() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
      msg = null;
    });
    try {
      ResponseModel resp =
          await login({'tel': phone.text, 'password': password.text});
      if (resp.success) {
        if (resp.otpRequired == true) {
          setState(() {
            token = resp.data['token'];
            otpRequired = resp.otpRequired as bool;
            msg = null;
          });
        } else {
          final sh = await SharedPreferences.getInstance();
          await sh.setString('token', resp.data['token']);
          if (sh.getBool("screened") == null) {
            await sh.setBool('screened', true);
          }
          Navigator.pushReplacementNamed(context, 'home');
        }
      } else {
        setState(() {
          msg = "الرجاء التأكد من معلومات الحساب";
        });
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

  verifyMyUser(String otp) async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
      msg = null;
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
            'تم التأكد من حسابك بنجاح!',
            style: GoogleFonts.cairo().copyWith(color: Colors.white),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(success);
        final sh = await SharedPreferences.getInstance();
        await sh.setString('token', token.toString());
        await sh.setBool('screened', true);
        Navigator.pushReplacementNamed(context, 'home');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/logo.png",
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 38.0,
                            left: 28,
                            right: 28,
                          ),
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
                              : otpRequired
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "الرجاء إدخال رمز التحقق الذي تم ارساله إلي هاتفك",
                                            style: GoogleFonts.cairo().copyWith(
                                              fontSize: 24,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 75,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: OTPTextField(
                                                controller: otpController,
                                                length: 4,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                textFieldAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                fieldWidth: 45,
                                                hasError: msg != null,
                                                fieldStyle:
                                                    FieldStyle.underline,
                                                outlineBorderRadius: 8,
                                                style: GoogleFonts.cairo()
                                                    .copyWith(fontSize: 17),
                                                onCompleted: (pin) async =>
                                                    await verifyMyUser(pin),
                                              ),
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
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .7,
                                      child: Form(
                                        key: _key,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
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
                                                    TextInputType.phone,
                                                controller: phone,
                                                validator: (value) => value ==
                                                        null
                                                    ? "please provide phone number"
                                                    : null,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .8),
                                                  label:
                                                      const Text("رقم الهاتف"),
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: password,
                                                obscureText: true,
                                                validator: (value) => value ==
                                                        null
                                                    ? "please provide password"
                                                    : null,
                                                textInputAction:
                                                    TextInputAction.done,
                                                decoration: InputDecoration(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .8),
                                                  label:
                                                      const Text("كلمة المرور"),
                                                ),
                                              ),
                                              if (msg != null)
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              if (msg != null)
                                                Text(
                                                  "$msg",
                                                  style: GoogleFonts.cairo()
                                                      .copyWith(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  final valid = _key
                                                      .currentState
                                                      ?.validate();
                                                  if (valid != null && valid) {
                                                    await loginIntoApp();
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10,
                                                    ),
                                                  ),
                                                ),
                                                icon: loading == true
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.white,
                                                      )
                                                    : const Icon(Icons.login),
                                                label: loading == false
                                                    ? const Text("تسجيل الدخول")
                                                    : const Text(""),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text("أو"),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              const RegisterScreen()));
                                                },
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 10,
                                                    ),
                                                  ),
                                                ),
                                                label:
                                                    const Text("مستخدم جديد"),
                                                icon: const Icon(Icons.person),
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
