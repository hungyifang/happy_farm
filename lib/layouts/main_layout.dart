import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  final Widget _body;
  final String _title;
  final int _index;

  const MainLayout(
      {super.key,
      required Widget body,
      required String title,
      required int index})
      : _body = body,
        _title = title,
        _index = index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: '牛棚',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar),
            label: '報名',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.military_tech),
            label: '徽章',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '設定',
            tooltip: '',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (value) {
          switch (value) {
            case 0:
              Get.toNamed('/bullpen');
              break;
            case 1:
              Get.toNamed('/register');
              break;
            case 2:
              Get.toNamed('/home');
              break;
            case 3:
              Get.toNamed('/gallery');
              break;
            case 4:
              Get.toNamed('/setting');
              break;
          }
        },
      ),
    );
  }
}
