import 'package:cakeday_reminder/abstractions/base_error.dart';
import 'package:cakeday_reminder/abstractions/cubit/base_state.dart';
import 'package:cakeday_reminder/configure_dependencies.dart';
import 'package:cakeday_reminder/ui/profile/profile_cubit.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileCubit _cubit = getIt<ProfileCubit>();

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
        child: BlocConsumer<ProfileCubit, BaseState>(
          bloc: _cubit,
          listener: _listenToState,
          builder: (context, state) => state is LoadingState
              ? _buildLosdingState()
              : _buildDefaultState(),
        ),
      ),
    );
  }

  void _listenToState(BuildContext context, BaseState state) {
    if (state is FailureState<BaseError>) {
      toastification.show(
        context: context,
        title: Text(state.error.message.tr,
            style: const TextStyle(
              color: Colors.white,
            )),
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.fillColored,
        type: ToastificationType.error,
        alignment: Alignment.topCenter,
      );
    } else if (state is SuccessDataState<String>) {
      toastification.show(
        context: context,
        title: Text(state.data.tr,
            style: const TextStyle(
              color: Colors.white,
            )),
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.fillColored,
        type: ToastificationType.success,
        alignment: Alignment.topCenter,
      );
    }
  }

  Widget _buildLosdingState() => Stack(
        alignment: Alignment.center,
        children: [
          AbsorbPointer(
            absorbing: true,
            child: Opacity(opacity: 0.6, child: _buildDefaultState()),
          ),
          const CircularProgressIndicator(
            color: AppColors.cornsilk,
          ),
        ],
      );

  Widget _buildDefaultState() => Column(
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
            items:
                _languages.keys.map<DropdownMenuItem<String>>((String value) {
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
          ElevatedButton(
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
            onPressed: _reloadNotifications,
            child: const Text(
              'Reload notifications',
              style: TextStyle(
                color: AppColors.cornsilk,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
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
            onPressed: _deleteAllBirthdays,
            child: const Text(
              'Delete all birthdays',
              style: TextStyle(
                color: AppColors.cornsilk,
              ),
            ),
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
      );

  Future _reloadNotifications() => _cubit.reloadNotifications();

  Future _deleteAllBirthdays() => _cubit.deleteAllBirthdays();

  Future _importBirthdays() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    final filePath = result?.files.single.path;

    if (filePath != null) {
      await _cubit.importBirthdaysFromFile(filePath);
    }
  }

  Future _exportBirthdays() => _cubit.exportBirthdaysAsXml();
}
