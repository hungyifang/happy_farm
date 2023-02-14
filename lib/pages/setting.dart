import 'package:flutter/material.dart';
import 'dart:convert';
// layout
import 'package:happy_farm/layouts/main_layout.dart';
// getX
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// auth
import 'package:happy_farm/services/google_auth.dart';
import 'package:happy_farm/services/line_auth.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});
  final box = GetStorage();
  final GoogleAuthService _googleAuth = GoogleAuthService();
  final LineAuthService _lineAuth = LineAuthService();

  @override
  Widget build(BuildContext context) {
    // print(box.read('user'));
    var user = jsonDecode(box.read('user'));
    var loginMethod = box.read('login_with');

    Widget body = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
          vertical: MediaQuery.of(context).size.height * 0.025),
      child: Column(
        children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.025),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user['photoURL']),
                radius: 100,
              )),
          Container(
              alignment: Alignment.center,
              child: Text(
                user['displayName'],
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800),
              )),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.015),
              child: OutlinedButton(
                onPressed: () async {
                  loginMethod == 'google'
                      ? await _googleAuth.signOut()
                      : await _lineAuth.signOut();
                  Get.toNamed('/');
                },
                style: OutlinedButton.styleFrom(
                  // backgroundColor: btnBgColor.value,
                  foregroundColor: Colors.red,
                  side: const BorderSide(width: 1.25, color: Colors.red),
                ),
                child: const Text('登出'),
              )),
        ],
      ),
    );

    return MainLayout(body: body, title: '設定', index: 4);
  }
}

// 圖片with loading
// Image(
//   image: user['photoURL'],
//   height: 120,
//   width: 120,
//   loadingBuilder: (BuildContext context, Widget child,
//       ImageChunkEvent? loadingProgress) {
//     if (loadingProgress == null) return child;
//     return Center(
//         child: CircularProgressIndicator(
//       value: loadingProgress.expectedTotalBytes != null
//           ? loadingProgress.cumulativeBytesLoaded /
//               loadingProgress.expectedTotalBytes!
//           : null,
//     ));
//   },
// ),
