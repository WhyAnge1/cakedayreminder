import 'package:cakeday_reminder/business_logic/export/export_provider.dart';
import 'package:cakeday_reminder/business_logic/import/import_provider.dart';
import 'package:cakeday_reminder/business_logic/notifications/notification_provider.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
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
        title: const Text(
          'Profile',
          style: TextStyle(
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(
                            color: AppColors.cornsilk,
                            width: 1,
                          ),
                        ),
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
                      const SizedBox(height: 10.0),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _exportBirthdays,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lion,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(
                                  color: AppColors.cornsilk,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Export birthdays',
                              style: TextStyle(
                                color: AppColors.cornsilk,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          ElevatedButton(
                            onPressed: _importBirthdays,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lion,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(
                                  color: AppColors.cornsilk,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Import birthdays',
                              style: TextStyle(
                                color: AppColors.cornsilk,
                              ),
                            ),
                          ),
                        ],
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

  Future _importBirthdays() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    final filePath = result?.files.single.path;

    if (filePath != null) {
      final result = await context
          .read<ImportProvider>()
          .importBirthdaysFromFile(filePath);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result
                ? 'cakedays_imported_successfully'.tr
                : 'failed_to_import_cakedays'.tr),
          ),
        );
      }
    }
  }

  Future _exportBirthdays() async {
    await context.read<ExportProvider>().exportBirthdaysAsXml();
  }
}
