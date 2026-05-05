// ignore_for_file: deprecated_member_use

import 'package:dio_receipe/core/utils/colors.dart';
import 'package:dio_receipe/views/layout/bottm_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyScaffoldWithNavBar extends StatelessWidget {
  const MyScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allows body to flow under the floating bar if desired
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: blackColor,
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: bottomNavBorderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  label: 'Home',
                  navigationShell: navigationShell,
                ),
                CustomNavItem(
                  index: 1,
                  icon: Icons.person_outline,
                  label: 'Profile',
                  navigationShell: navigationShell,
                ),
                CustomNavItem(
                  index: 2,
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  navigationShell: navigationShell,
                ),
                CustomNavItem(
                  index: 3,
                  icon: Icons.info_outline,
                  label: 'About',
                  navigationShell: navigationShell,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
