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
    100:const Color.fromARGB(8, 136, 14, 79),
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

  static ThemeData darkmode = ThemeData(
      primaryColor: Colors.white,
      primarySwatch: colorCustom,
      scaffoldBackgroundColor: colorCustom,
      bottomAppBarColor: colorCustom,
      shadowColor: darkBG,
      bottomNavigationBarTheme:   BottomNavigationBarThemeData(
        backgroundColor: Colors.white70,
        elevation: 10,
        selectedLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 8, 8, 8), fontSize: 14.0
        ),
        unselectedLabelStyle: GoogleFonts.cairo(
            color: const Color.fromARGB(255, 175, 169, 169), fontSize: 12.0
        ),
        selectedItemColor: const Color.fromARGB(255, 63, 62, 60),
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
    ),
      //backgroundColor: const Color.fromARGB(255, 248, 246, 246),
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
        color: Colors.grey,
      )), colorScheme: ColorScheme.fromSwatch(primarySwatch: colorCustom).copyWith(secondary: Colors.white));
}
