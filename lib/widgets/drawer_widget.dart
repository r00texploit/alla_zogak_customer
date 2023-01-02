import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:alla_zogak_customer/screens/profile.dart';
import 'package:alla_zogak_customer/widgets/theme/theme_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:alla_zogak_customer/widgets/constants.dart';

import '../providers/user_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/my_orders_drawer.dart';
import '../screens/wishlist_drawer.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late UserBloc user;
  open(Widget screen) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserBloc>(context);
    WishlistBloc wishlist = Provider.of<WishlistBloc>(context);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return SafeArea(
        child: Drawer(
          backgroundColor: themeNotifier.isDark ? Colors.white : Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  if (user.user != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        left: 8,
                        right: 8,
                        bottom: 5,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://yoo2.smart-node.net${user.user?.avatar}",
                                errorWidget: (context, url, error) =>
                                    Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
                                  fit: BoxFit.fill,
                                  scale: 1,
                                  errorBuilder: (context, error, stackTrace) {
                                    if (kDebugMode) {
                                      print(error);
                                    }
                                    return const Icon(Icons.info);
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user.user?.name}",
                                style: GoogleFonts.cairo().copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  Divider(
                    thickness: 2,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => open(const MyProfile()),
                          child: ListTile(
                            leading: const Icon(
                              Icons.person,
                            ),
                            title: Text(
                              "الملف الشخصي",
                              style: GoogleFonts.cairo().copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        InkWell(
                          onTap: () => open(const MyOrderDrawer()),
                          child: ListTile(
                            leading: const Icon(
                              Icons.list,
                            ),
                            title: Text(
                              "طلباتي",
                              style: GoogleFonts.cairo().copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        InkWell(
                          onTap: () => open(const WishlistDrawer()),
                          child: ListTile(
                            leading: Stack(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.grey,
                                ),
                                if (wishlist.total != 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color:
                                                Theme.of(context).scaffoldBackgroundColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          wishlist.total < 9
                                              ? wishlist.total.toString()
                                              : '+9',
                                          style: GoogleFonts.cairo().copyWith(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(
                              "قائمة الرغبات",
                              style: GoogleFonts.cairo().copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        InkWell(
                          onTap: () async {
                            await launchUrl(
                              Uri.parse("https://wa.me/message/IHM5LEPTSCIVH1"),
                              webViewConfiguration: const WebViewConfiguration(
                                enableDomStorage: true,
                                enableJavaScript: true,
                              ),
                              webOnlyWindowName: "_blank",
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: ListTile(
                            leading: const Icon(
                              Icons.whatsapp,
                            ),
                            title: Text(
                              "تواصل معنا",
                              style: GoogleFonts.cairo().copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // ignore: unrelated_type_equality_checks
                      //if(AdaptiveTheme.getThemeMode() == AdaptiveThemeMode.dark){
                      themeNotifier.isDark
                          ? themeNotifier.isDark = false
                          : themeNotifier.isDark = true;
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.dark_mode,
                      ),
                      title: Text(
                        "المظهر الليلي",
                        style: GoogleFonts.cairo().copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  final sh = await SharedPreferences.getInstance();
                  await sh.remove("token");
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, 'login');
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    "تسجيل خروج",
                    style: GoogleFonts.cairo().copyWith(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
