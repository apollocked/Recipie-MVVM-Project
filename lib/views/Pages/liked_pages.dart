import 'package:dio_receipe/views/layout/custom_appbar.dart';
import 'package:flutter/material.dart';

class LikedReciepesPage extends StatelessWidget {
  const LikedReciepesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Liked Reciepes'),
      body: Center(child: Text('LikedReciepesPage')),
    );
  }
}
