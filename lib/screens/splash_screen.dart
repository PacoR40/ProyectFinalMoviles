import 'package:flutter/material.dart';
import 'package:practica7/screens/login_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: LoginScreen(),
      //duration: 4000,
      imageSize: 300,
      imageSrc: "assets/groceryLogo.png",
      text: "Grocery Control",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.white,
    );
  }
}