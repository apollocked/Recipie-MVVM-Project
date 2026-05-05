import 'package:dio_receipe/core/utils/colors.dart';
import 'package:flutter/material.dart';

AppBar customAppBar(
  String title, {
  Widget child = const SizedBox.shrink(key: Key("emptyKey")),
}) {
  return AppBar(
    toolbarHeight: 65,
    backgroundColor: yellowColor,
    centerTitle: child.key == Key("emptyKey") ? true : false,
    shadowColor: shadowColor,
    scrolledUnderElevation: 0,
    elevation: 5,
    title: Text(
      title,
      style: TextStyle(
        color: blackColor,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        fontSize: 20,
      ),
    ),
    actions: [child],
  );
}
