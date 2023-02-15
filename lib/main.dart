import 'package:flutter/material.dart';
// auth
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// getX
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// pages
import 'package:happy_farm/pages/splash.dart';
import 'package:happy_farm/pages/home.dart';
import 'package:happy_farm/pages/login.dart';
import 'package:happy_farm/pages/setting.dart';
import 'package:happy_farm/pages/bullpen.dart';
import 'package:happy_farm/pages/gallery.dart';
import 'package:happy_farm/pages/register.dart';
import 'package:happy_farm/pages/recruit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LineSDK.instance.setup("1657830017").then((_) {});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Loading and Splash
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: SplashPage(),
            // debugShowCheckedModeBanner: false, // 去除右上方Debug標誌
          );
        }
        // Main pages
        else {
          return GetMaterialApp(
              title: 'HappyFarm',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'NotoSansTC'
              ),
              initialRoute: '/',
              // debugShowCheckedModeBanner: false, // 去除右上方Debug標誌
              // unknownRoute: GetPage(name: '/notfound', page: () => UnknownRoutePage()), // 404 page
              getPages: [
                GetPage(
                  name: '/',
                  page: () {
                    if (box.hasData('remember')) {
                      if (box.read('remember') == 'true' &&
                          box.hasData('user')) {
                        return const HomePage();
                      }

                      box.erase();
                      return LoginPage();
                    }
                    return LoginPage();
                  },
                ),
                GetPage(
                  name: '/home',
                  page: () {
                    return const HomePage();
                  },
                ),
                GetPage(
                  name: '/setting',
                  page: () {
                    return SettingPage();
                  },
                ),
                GetPage(
                  name: '/bullpen',
                  page: () {
                    return const BullpenPage();
                  },
                ),
                GetPage(
                  name: '/gallery',
                  page: () {
                    return const GalleryPage();
                  },
                ),
                GetPage(
                  name: '/register',
                  page: () {
                    return RegisterPage();
                  },
                ),
                GetPage(
                  name: '/recruit',
                  page: () {
                    return RecruitPage();
                  },
                  
                ),
              ]);
        }
      },
    );
  }
}
