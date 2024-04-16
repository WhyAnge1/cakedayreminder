import 'package:cakeday_reminder/business_logic/notifications/notification_provider.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, Locale> _languages = const {
    'English': Locale('en', 'UK'),
    'Українська': Locale('uk', 'UA')
  };
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();

    _selectedLanguage = _languages.entries
            .firstWhereOrNull((element) =>
                element.value.languageCode == Get.locale?.languageCode)
            ?.key ??
        _languages.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.resedaGreen,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.lion,
        foregroundColor: AppColors.cornsilk,
        title: Text(
          'Profile',
          style: const TextStyle(
            color: AppColors.cornsilk,
          ),
        ),
      ),
      body: Center(
        child: Consumer<NotificationProvider>(
          builder: (context, provider, child) => Stack(
            alignment: Alignment.center,
            children: [
              AbsorbPointer(
                absorbing: provider.isReloadingNotifications,
                child: Opacity(
                  opacity: provider.isReloadingNotifications ? 0.6 : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        value: _selectedLanguage,
                        dropdownColor: AppColors.lion,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue!;
                            Get.updateLocale(_languages[newValue]!);
                          });
                        },
                        items: _languages.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: AppColors.cornsilk,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10.0),
                      FloatingActionButton.extended(
                        backgroundColor: AppColors.lion,
                        label: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          child: Text(
                            'Reload notifications',
                            style: TextStyle(
                              color: AppColors.cornsilk,
                            ),
                          ),
                        ),
                        onPressed: _reloadNotifications,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: provider.isReloadingNotifications,
                child: const CircularProgressIndicator(
                  color: AppColors.cornsilk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _reloadNotifications() async {
    await context.read<NotificationProvider>().reloadNotifications();
  }
}
