import 'package:dio_receipe/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

AppBar customAppBar(
  String title, {
  Widget child = const SizedBox.shrink(key: Key("emptyKey")),
}) {
  return AppBar(
    toolbarHeight: 65,
    backgroundColor: AppColors.accent,
    centerTitle: child.key == Key("emptyKey") ? true : false,
    shadowColor: AppColors.shadow,
    scrolledUnderElevation: 0,
    elevation: 5,
    title: Text(
      title,
      style: TextStyle(
        color: AppColors.textOnAccent,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        fontSize: 20,
      ),
    ),
    actions: [child],
  );
}
