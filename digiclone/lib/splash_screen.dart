import 'package:flutter/material.dart';
import 'option.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToButtonPage(context); // Change to navigate to Button Page
  }

  Future<void> navigateToButtonPage(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ButtonPage()), // Navigate to Button Page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 3, 31, 73),
      child: Center(
        child: Image.asset(
          'assets/app_icon.png', // Replace with your app icon image path
          width: 400.0,
          height: 400.0,
        ),
      ),
    );
  }
}
