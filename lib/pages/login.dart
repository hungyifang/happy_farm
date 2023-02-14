import 'package:flutter/material.dart';
// getX
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// auth
import 'package:happy_farm/services/google_auth.dart';
import 'package:happy_farm/services/line_auth.dart';
// UI
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// extension method
import 'package:happy_farm/extensions/firebase_auth_user.dart'; // for data to json

class LoginPage extends StatelessWidget {
  LoginPage({super.key, this.title = '登入'});
  final String title;
  final GoogleAuthService _googleAuth = GoogleAuthService();
  final LineAuthService _lineAuth = LineAuthService();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var isChecked = false.obs;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: MediaQuery.of(context).size.height * 0.075),
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SignInButton(
            Buttons.GoogleDark,
            text: "使用 Google 登入",
            onPressed: () async {
              final user = await _googleAuth.signInWithGoogle();
              if (user != null) {
                var json = user.toJson();
                box.write('user', json);
                box.write('login_with', 'google');
                box.write('remember', isChecked.value.toString());
                //print(box.read('user'));
                Get.toNamed('/home');
              }
            },
          ),
          SignInButtonBuilder(
            padding: const EdgeInsets.all(0.0),
            innerPadding: const EdgeInsets.fromLTRB(4, 1.5, 12.5, 1.0),
            image: const FaIcon(FontAwesomeIcons.line,
                size: 32.5, color: Color.fromARGB(255, 255, 255, 255)),
            text: "使用 Line 登入",
            textColor: Colors.white,
            onPressed: () async {
              final user = await _lineAuth.signInWithLine();
              if (user != null) {
                var json = user.toJson();
                box.write('user', json);
                box.write('login_with', 'line');
                box.write('remember', isChecked.value.toString());
                //print(box.read('user'));
                Get.toNamed('/home');
              }
            },
            backgroundColor: const Color.fromARGB(255, 0, 185, 0),
          ),
          Container(
            // color: Colors.blue,
            alignment: Alignment.center,
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
            // transform: Matrix4.translationValues(-15, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() => Checkbox(
                      checkColor: Colors.white,
                      // fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked.value,
                      onChanged: (bool? value) {
                        if (value != null) {
                          isChecked.value = value;
                        }
                      },
                    )),
                Container(
                  transform: Matrix4.translationValues(-10, 0, 0),
                  child: const Text(
                    '保持登入',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
