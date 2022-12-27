import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practica7/screens/select_theme.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../provider/theme_provider2.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({Key? key}) : super(key: key);

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {

  final controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
              setState(() => isLastPage = index ==2 );
          },
          children: [
            buildPage(
              color: Color.fromARGB(255, 231, 246, 242),
              urlImage: 'assets/view1.png',
              title: 'Digitize your business',
              colortext: Color.fromARGB(255, 41, 51, 51),
              subtitle: 'Control your business from anywhere on your mobile device, with "Grocery" you can be aware of everything related to your business.',
            ),
            buildPageContent(),
            buildPage(
              color: Color.fromARGB(255, 18, 58, 90),
              urlImage: 'assets/view2.png',
              title: 'Upload your products',
              colortext: Color.fromARGB(255, 255, 255, 255),
              subtitle: 'Register all your products so that you can keep track of them, you can observe them and interact with them dynamically.',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage  ? TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            primary: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
            backgroundColor: themeProvider.isLightTheme
                        ? Colors.white70
                        : Colors.black87,
            minimumSize: const Size.fromHeight(80),
          ),
        onPressed: () async {
          Navigator.pushNamed(context, '/dashboard');
        },
        child: const Text(
          '¡GO!',
          style: TextStyle(fontSize: 24),
        ),
      ) : Container(
        color: themeProvider.isLightTheme
                        ? Color.fromARGB(26, 30, 30, 30)
                        : Color.fromARGB(255, 97, 94, 94),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                primary: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
              ),
              child: const Text('SKIP'),
              onPressed: () => controller.jumpToPage(2),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: Theme.of(context).primaryColor,
                  activeDotColor: Color.fromARGB(255, 142, 143, 143),
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: themeProvider.isLightTheme
                        ? Colors.black
                        : Colors.white,
              ),
              child: const Text('NEXT'),
              onPressed: () => controller.nextPage(
                duration: const Duration(microseconds: 500),
                curve: Curves.easeInOut,
              )
            ),
          ],
        ),
      ) 
    );
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
    required Color colortext,
  }) => Container(
    color: color,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          urlImage,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: colortext,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colortext,
              fontSize: 17
              ),
          ),
        )
      ],
    ),
  );

  Widget buildPageContent() => Scaffold(
    body: HomePage()
  );

}