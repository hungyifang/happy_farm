import 'package:flutter/material.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.callback(
      name: 'assets/material_loader.riv',
      onSuccess: (data) => {},
      onError: (err, stack) {
        //error throw by until callback function
      },
      until: () => Future.delayed(const Duration(seconds: 2)),
      startAnimation: 'animate',
      fit: BoxFit.fitHeight,
    );
  }
}
