import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static bool isdarkmode = false;

  static initTheme() async {
    final sh = await SharedPreferences.getInstance();
    await sh.setBool("theme", Constants.isdarkmode);
  }

  // static initTheme() async {
  //   final sh = await SharedPreferences.getInstance();
  //   await sh.setBool("theme", isdarkmode);
  // }

  static Future<bool?> getThemeInstance() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    bool? theme = instance.getBool("theme");
    return theme;
  }

  static Color darkAccent = const Color(0xff886EE4);
  static Color lightBG = const Color(0xfff3f4f9);
  static Color darkBG = const Color(0xff2B2B2B);
  static Color darkPrimary = const Color(0xff2B2B2B);
  static Color lightPrimary = const Color.fromARGB(255, 245, 243, 243);

  static Map<int, Color> color = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromARGB(8, 136, 14, 79),
    200: const Color.fromARGB(123, 10, 0, 6),
    300: const Color.fromARGB(102, 20, 1, 11),
    400: const Color.fromARGB(126, 51, 39, 45),
    500: const Color.fromARGB(153, 36, 30, 33),
    600: const Color.fromARGB(177, 29, 22, 25),
    700: const Color.fromARGB(204, 24, 2, 14),
    800: const Color.fromARGB(227, 24, 15, 20),
    900: const Color.fromARGB(255, 15, 3, 9),
  };
  static MaterialColor colorCustom = MaterialColor(0xFF000000, color);
  static ThemeData lightmode = ThemeData(
      primarySwatch: Colors.yellow,
        textTheme: TextTheme(
        headline1: GoogleFonts.cairo().copyWith(color: Colors.black54),
        headline2: GoogleFonts.cairo().copyWith(color: Colors.black54),
        headline3: GoogleFonts.cairo().copyWith(color: Colors.black54),
        headline4: GoogleFonts.cairo().copyWith(color: Colors.black54),
        headline5: GoogleFonts.cairo().copyWith(color: Colors.black54),
        headline6: GoogleFonts.cairo().copyWith(color: Colors.black54),
        subtitle1: GoogleFonts.cairo().copyWith(color: Colors.black54),
        subtitle2: GoogleFonts.cairo().copyWith(color: Colors.black54),
      ),
      iconTheme: const IconThemeData(
        color: Colors.grey,
      ),
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.cairo().copyWith(
        color: Colors.black,
      )));

  // static ThemeData darkmode = ThemeData(
  //   primaryColor: Colors.black,
  //   brightness: Brightness.dark,
  //   backgroundColor: const Color(0xFF212121),
  //   dividerColor: Colors.black12, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(secondary: Colors.white),
  // );

  static ThemeData darkmode = ThemeData(
      primarySwatch: colorCustom,
      scaffoldBackgroundColor: colorCustom,
      bottomAppBarColor: Colors.grey,
      //brightness: Brightness.dark,
      shadowColor: darkBG,
      cardColor: Colors.grey,
      textTheme: TextTheme(
        headline1: GoogleFonts.cairo().copyWith(color: Colors.white54),
        headline2: GoogleFonts.cairo().copyWith(color: Colors.white54),
        headline3: GoogleFonts.cairo().copyWith(color: Colors.white54),
        headline4: GoogleFonts.cairo().copyWith(color: Colors.white54),
        headline5: GoogleFonts.cairo().copyWith(color: Colors.white54),
        headline6: GoogleFonts.cairo().copyWith(color: Colors.white54),
        subtitle1: GoogleFonts.cairo().copyWith(color: Colors.white54),
        subtitle2: GoogleFonts.cairo().copyWith(color: Colors.white54),
      ),
      iconTheme: const IconThemeData(
        color: Colors.grey,
      ),
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.cairo().copyWith(
        color: Colors.grey,
      )),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
          .copyWith(secondary: Colors.white));
}
