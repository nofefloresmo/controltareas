import 'package:flutter/material.dart';
import '../pages/home_page.dart';

void main() {
  runApp(const AppU3P2());
}

class AppU3P2 extends StatelessWidget {
  const AppU3P2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App U3 P2',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}
