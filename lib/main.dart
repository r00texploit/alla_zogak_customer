import 'package:alla_zogak_customer/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../models/products.dart';
import '../providers/address_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/login_screen.dart';
import 'providers/user_provider.dart';
import 'screens/Landing/intro_slider.dart';
import 'screens/Landing/splash.dart';
import 'screens/home_page.dart';
import 'screens/product_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartBloc()),
      ChangeNotifierProvider(create: (_) => WishlistBloc()),
      ChangeNotifierProvider(create: (_) => AddressBloc()),
      ChangeNotifierProvider(create: (_) => UserBloc())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Di',
      theme: ThemeData(
        //primarySwatch: Colors.yellow,
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
          )
        )
      ),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "intro":
            return MaterialPageRoute(builder: (_) => const IntroSliderScreen());
          case "login":
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case "home":
            return MaterialPageRoute(builder: (_) => const HomePage());
          case "product":
            return MaterialPageRoute(
                builder: (_) => ProductSc(
                      product: settings.arguments as Products,
                    ));
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
      locale: const Locale("ar", "SA"),
      supportedLocales: const [Locale("ar", "SA")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
