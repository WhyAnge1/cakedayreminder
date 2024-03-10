import 'package:cakeday_reminder/ui/home/home_page.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: AppColors.resedaGreen,
      theme: ThemeData(
        useMaterial3: true,
        indicatorColor: AppColors.cornsilk,
      ),
      home: const HomePage(),
    );
  }
}
