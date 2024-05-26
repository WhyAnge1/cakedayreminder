import 'package:cakeday_reminder/configure_dependencies.dart';
import 'package:cakeday_reminder/firebase_options.dart';
import 'package:cakeday_reminder/ui/home/home_page.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'business_logic/constants/messages.dart';
import 'package:timezone/data/latest.dart' as tz;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await configureDependencies();
  await initNotifications();
  requestAndroidPermissions();
  await initFirebase();

  runApp(const MyApp());

  FirebaseAnalytics.instance.logAppOpen();
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

Future requestAndroidPermissions() async {
  final androidotificationsPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidotificationsPlugin?.requestNotificationsPermission();
  await androidotificationsPlugin?.requestExactAlarmsPermission();
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) {
  debugPrint(
      'onDidReceiveNotificationResponse: notification payload: ${notificationResponse.payload}');
}

Future initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
