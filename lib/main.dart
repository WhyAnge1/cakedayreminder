import 'package:cakeday_reminder/business_logic/birthday/birthday_provider.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_service.dart';
import 'package:cakeday_reminder/business_logic/export/export_provider.dart';
import 'package:cakeday_reminder/business_logic/export/export_service.dart';
import 'package:cakeday_reminder/business_logic/import/import_provider.dart';
import 'package:cakeday_reminder/business_logic/import/import_service.dart';
import 'package:cakeday_reminder/business_logic/notifications/notification_provider.dart';
import 'package:cakeday_reminder/business_logic/notifications/notification_service.dart';
import 'package:cakeday_reminder/ui/home/home_page.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'business_logic/constants/messages.dart';
import 'package:timezone/data/latest.dart' as tz;

final getIt = GetIt.instance;
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  runApp(const MyApp());

  tz.initializeTimeZones();

  registerDependencies();
  initNotifications();
  requestAndroidPermissions();
}

void registerDependencies() {
  getIt.registerSingleton(ImportService());
  getIt.registerSingleton(ExportService());
  getIt.registerSingleton(NotificationService());
  getIt.registerSingleton(BirthdayService());
}

Future<void> initNotifications() async {
  final androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      debugPrint(
          'onDidReceiveLocalNotification: int $id, String? $title, String? $body, String? $payload');
    },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse);
}

void requestAndroidPermissions() {
  final androidotificationsPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  androidotificationsPlugin?.requestNotificationsPermission();
  androidotificationsPlugin?.requestExactAlarmsPermission();
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) {
  debugPrint(
      'onDidReceiveNotificationResponse: notification payload: ${notificationResponse.payload}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BirthdayProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => ImportProvider()),
        ChangeNotifierProvider(create: (context) => ExportProvider()),
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
