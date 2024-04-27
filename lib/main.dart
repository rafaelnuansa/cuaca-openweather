import 'package:flutter/material.dart';
import 'package:uts_mobile_programming/screens/weather_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Hide debug banner
      home: WeatherScreen(),
    );
  }
}
