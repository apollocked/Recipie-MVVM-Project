import 'package:dio_receipe/presentation/layout/custom_appbar.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Info'),
      body: Center(child: Text('InfoPage')),
    );
  }
}
