import 'package:alla_zogak_customer/providers/wishlist_provider.dart';
import 'package:alla_zogak_customer/widgets/constants.dart';
import 'package:alla_zogak_customer/widgets/theme/style.dart';
import 'package:alla_zogak_customer/widgets/theme/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
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
import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartBloc()),
      ChangeNotifierProvider(create: (_) => WishlistBloc()),
      ChangeNotifierProvider(create: (_) => AddressBloc()),
      ChangeNotifierProvider(create: (_) => UserBloc())
    ],
    child: MyApp(savedThemeMode: savedThemeMode),
  ));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            builder: (context, child) => ResponsiveWrapper.builder(
              child,
              // maxWidth: 1920,
              // minWidth: 750,
              debugLog: true,
              // mediaQueryData: MediaQueryData(),
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.autoScale(370, name: MOBILE,scaleFactor: 0),
                // const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                // const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ],
              // background: Container(color: Color(0xFFF5F5F5))
            ),
            debugShowCheckedModeBanner: false,
            title: 'Super Digital Market',
            // ignore: unrelated_type_equality_checks
            theme: //Styles.themeData(themeNotifier.isDark, context),
                themeNotifier.isDark ? Constants.darkmode : Constants.lightmode,
            initialRoute: "/",
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case "intro":
                  return MaterialPageRoute(
                      builder: (_) => const IntroSliderScreen());
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
                  return MaterialPageRoute(
                      builder: (_) => const SplashScreen());
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
        }));
  }
}
