import 'package:flutter/material.dart';
import 'package:happy_farm/layouts/main_layout.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  @override
  Widget build(BuildContext context) {
    Widget body = const Text('badges');
    return MainLayout(body: body, title: '徽章', index: 3);
  }
}