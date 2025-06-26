import 'package:flutter/material.dart';

class SplashPage1 extends StatelessWidget {
  const SplashPage1({super.key});

  @override
  Widget build(BuildContext context) {
    var name = 'assets/images/logos.png';
    return Center(
      child: Image.asset(
        name,
        width: 300,
      ),
    );
  }
}
