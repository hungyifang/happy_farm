import 'package:flutter/material.dart';
import 'package:happy_farm/layouts/main_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    Widget body = const Text('home');
    return MainLayout(body: body, title: '首頁', index: 2);
  }
}