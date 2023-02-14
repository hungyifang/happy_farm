import 'package:flutter/material.dart';
import 'package:happy_farm/layouts/main_layout.dart';

class BullpenPage extends StatelessWidget {
  const BullpenPage({super.key});
  @override
  Widget build(BuildContext context) {
    Widget body = const Text('bullpen');
    return MainLayout(body: body, title: '牛棚', index: 0);
  }
}