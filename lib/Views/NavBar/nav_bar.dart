import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Views/NavBar/Account/account_screen.dart';
import 'package:ourtalks/Views/NavBar/Home/home_screen.dart';
import 'package:ourtalks/main.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0; // NAV BAR INDEX
  // NAV BAR SHOW SCREEN(WIDGET) LIST
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // HOME SCREEN
    Text(
      'Likes',
    ),
    AccountScreen(), // ACCOUNT SCREEN
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // CALL WIDGET
      ),
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 8.h),
          child: GNav(
            rippleColor: cnstSheet.colors.primary.withValues(alpha: 150),
            hoverColor: cnstSheet.colors.secondary,
            gap: 6.w,
            activeColor: cnstSheet.colors.primary,
            iconSize: 24.sp,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            duration: Duration(milliseconds: 300),
            tabActiveBorder: Border.all(
              color: cnstSheet.colors.primary,
              style: BorderStyle.solid,
            ),
            tabBorderRadius: 10.r,
            color: cnstSheet.colors.primary.withValues(alpha: 100),
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: LanguageConst.home.tr,
              ),
              GButton(
                icon: Icons.favorite_border_rounded,
                text: LanguageConst.search.tr,
              ),
              GButton(
                icon: Icons.person_2_outlined,
                text: LanguageConst.account.tr,
              ),
            ],
            textStyle: cnstSheet.textTheme.fs14Normal
                .copyWith(color: cnstSheet.colors.primary),
            selectedIndex: _selectedIndex,
            curve: Easing.standardAccelerate,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
