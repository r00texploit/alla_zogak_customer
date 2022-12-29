import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {

  static bool isdarkmode = false;

 static initTheme() async {
    final sh = await SharedPreferences.getInstance();
    await sh.setBool("theme", Constants.isdarkmode);
  }

  static Future<bool?> getThemeInstance() async {
   SharedPreferences instance = await SharedPreferences.getInstance();
    bool? theme = instance.getBool("theme");
    return theme;
  }

  static Color darkAccent = const Color(0xff886EE4);
  static Color lightBG = const Color(0xfff3f4f9);
  static Color darkBG = const Color(0xff2B2B2B);
  static Color darkPrimary = const Color(0xff2B2B2B);

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
    )),
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextTheme(
        headline6: GoogleFonts.cairo().copyWith(
          color: Colors.black,
          fontSize: 20,
        ),
      ).bodyText2,
      titleTextStyle: TextTheme(
        headline6: GoogleFonts.cairo().copyWith(
          color: Colors.black,
          fontSize: 20,
        ),
      ).headline6,
    ),
  );
  static ThemeData darkmode = ThemeData(
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
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: darkAccent,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0,
      color: darkBG,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextTheme(
        headline6: TextStyle(
          color: lightBG,
          fontSize: 20,
        ),
      ).bodyText2,
      titleTextStyle: TextTheme(
        headline6: TextStyle(
          color: lightBG,
          fontSize: 20,
        ),
      ).headline6,
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow)
        .copyWith(secondary: darkAccent),
  );
}
