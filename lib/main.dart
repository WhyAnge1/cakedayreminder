import 'package:cakeday_reminder/business_logic/birthday/birthday_provider.dart';
import 'package:cakeday_reminder/business_logic/import/import_service.dart';
import 'package:cakeday_reminder/ui/home/home_page.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'business_logic/constants/messages.dart';

final getIt = GetIt.instance;

void main() {
  runApp(const MyApp());

  registerDependencies();
}

void registerDependencies() {
  getIt.registerSingleton(ImportService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BirthdayProvider()),
      ],
      child: GetMaterialApp(
        translations: Messages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'UK'),
        color: AppColors.resedaGreen,
        theme: ThemeData(
          useMaterial3: true,
          indicatorColor: AppColors.cornsilk,
        ),
        home: const HomePage(),
      ),
    );
  }
}
