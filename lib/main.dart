import 'package:cakeday_reminder/ui/home/home_page.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'business_logic/constants/messages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'UK'),
      color: AppColors.resedaGreen,
      theme: ThemeData(
        useMaterial3: true,
        indicatorColor: AppColors.cornsilk,
      ),
      home: const HomePage(),
    );
  }
}
