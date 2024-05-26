import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/configure_dependencies.dart';
import 'package:cakeday_reminder/ui/create_birthday/create_birthday_cubit.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class CreateBirthdayPage extends StatefulWidget {
  const CreateBirthdayPage({super.key});

  @override
  State createState() => _CreateBirthdayPageState();
}

class _CreateBirthdayPageState extends State<CreateBirthdayPage> {
  final CreateBirthdayCubit _cubit = getIt<CreateBirthdayCubit>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool? _idkYear = true;
  String get _selectedDateDisplayString => _idkYear!
      ? DateFormat('dd MMMM').format(_selectedDate)
      : DateFormat('dd MMMM y').format(_selectedDate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.resedaGreen,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.lion,
        foregroundColor: AppColors.cornsilk,
        title: Text(
          'add_missed_cakeday'.tr,
          style: const TextStyle(
            color: AppColors.cornsilk,
          ),
        ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(
                  color: AppColors.cornsilk,
                  width: 1,
                ),
              ),
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
              onPressed: () async => await _saveBirthday(),
            ),
          ],
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
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

  Future _saveBirthday() async {
    if (_nameController.text.isNotEmpty) {
      await _cubit.createBirthday(BirthdayModel(
        personName: _nameController.text,
        birthdayDate: DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day),
        note: _descriptionController.text,
      ));

      if (context.mounted) {
        toastification.show(
          context: context,
          title: Text('new_cakeday_saved_successfully'.tr,
              style: const TextStyle(
                color: Colors.white,
              )),
          autoCloseDuration: const Duration(seconds: 5),
          style: ToastificationStyle.fillColored,
          type: ToastificationType.success,
          alignment: Alignment.topCenter,
        );

        Navigator.of(context).pop();
      }
    }
  }
}
