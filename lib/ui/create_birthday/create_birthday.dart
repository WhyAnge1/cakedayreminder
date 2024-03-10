import 'dart:io';

import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_service.dart';
import 'package:cakeday_reminder/business_logic/import/import_service.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class CreateBirthdayPage extends StatefulWidget {
  const CreateBirthdayPage({super.key});

  @override
  State createState() => _CreateBirthdayPageState();
}

class _CreateBirthdayPageState extends State<CreateBirthdayPage> {
  final _importService = ImportService();
  final _birthdayService = BirthdayService();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool? _idkYear = true;
  String get _selectedDateDisplayString => _idkYear!
      ? DateFormat('dd MMMM').format(_selectedDate)
      : DateFormat('dd MMMM y').format(_selectedDate);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(0),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate =
          DateTime(_idkYear! ? 0 : picked.year, picked.month, picked.day);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.resedaGreen,
      appBar: AppBar(
        backgroundColor: AppColors.lion,
        foregroundColor: AppColors.cornsilk,
        title: Text(
          'add_missed_cakeday'.tr,
          style: const TextStyle(
            color: AppColors.cornsilk,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['xlsx', 'xls'],
              );

              final filePath = result?.files.single.path;

              if (filePath != null) {
                final result = await _importService
                    .importBirthdaysFromExel(File(filePath));

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
            },
            icon: const Icon(
              Icons.upload_file,
              color: AppColors.cornsilk,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(
                color: AppColors.cornsilk,
              ),
              controller: _nameController,
              cursorColor: AppColors.cornsilk,
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.cornsilk,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.cornsilk,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: AppColors.cornsilk,
                ),
                labelText: 'person_name'.tr,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(
                    Icons.calendar_month,
                    color: AppColors.lion,
                  ),
                ),
                Text(
                  _selectedDateDisplayString,
                  style: const TextStyle(
                    color: AppColors.cornsilk,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Checkbox(
                  activeColor: AppColors.lion,
                  value: _idkYear,
                  onChanged: (bool? checked) {
                    _idkYear = checked;

                    _selectedDate = DateTime(_idkYear! ? 0 : _selectedDate.year,
                        _selectedDate.month, _selectedDate.day);

                    setState(() {});
                  },
                ),
                Text(
                  "i_don_t_know_year".tr,
                  style: const TextStyle(
                    color: AppColors.cornsilk,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            TextField(
              style: const TextStyle(
                color: AppColors.cornsilk,
              ),
              controller: _descriptionController,
              cursorColor: AppColors.cornsilk,
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.cornsilk,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.cornsilk,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: AppColors.cornsilk,
                ),
                labelText: 'some_notes_to_not_forget'.tr,
              ),
            ),
            const SizedBox(height: 15.0),
            FloatingActionButton.extended(
              backgroundColor: AppColors.lion,
              label: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: Text(
                  'save'.tr,
                  style: const TextStyle(
                    color: AppColors.cornsilk,
                  ),
                ),
              ),
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await _birthdayService.saveBirthday(BirthdayModel(
                    personName: _nameController.text,
                    birthdayDate: DateTime(_selectedDate.year,
                        _selectedDate.month, _selectedDate.day),
                    note: _descriptionController.text,
                  ));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('new_cakeday_saved_successfully'.tr),
                      ),
                    );

                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
