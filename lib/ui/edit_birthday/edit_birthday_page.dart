import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/configure_dependencies.dart';
import 'package:cakeday_reminder/ui/edit_birthday/edit_birthday_cubit.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditBirthdayPage extends StatefulWidget {
  final BirthdayModel birthday;

  const EditBirthdayPage({super.key, required this.birthday});

  @override
  State createState() => _EditBirthdayPageState();
}

class _EditBirthdayPageState extends State<EditBirthdayPage> {
  final EditBirthdayCubit _cubit = getIt<EditBirthdayCubit>();

  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  bool? _idkYear = true;
  String get _selectedDateDisplayString =>
      _idkYear! || widget.birthday.birthdayDate.year == 0
          ? DateFormat('dd MMMM').format(widget.birthday.birthdayDate)
          : DateFormat('dd MMMM y').format(widget.birthday.birthdayDate);

  @override
  void initState() {
    _nameController.text = widget.birthday.personName;
    _noteController.text = widget.birthday.note;
    _idkYear = widget.birthday.birthdayDate.year == 0;

    super.initState();
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
          'edit_cakeday'.tr,
          style: const TextStyle(
            color: AppColors.cornsilk,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showDeleteConfirmation(context);
            },
            icon: const Icon(Icons.delete),
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
                    widget.birthday.birthdayDate = DateTime(
                        _idkYear! ? 0 : widget.birthday.birthdayDate.year,
                        widget.birthday.birthdayDate.month,
                        widget.birthday.birthdayDate.day);
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
              controller: _noteController,
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
              onPressed: () async => await _updateBirthday(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.lion,
          title: Text(
            'are_you_sure'.tr,
            style: const TextStyle(
              color: AppColors.cornsilk,
            ),
          ),
          content: Text(
            'you_are_going_to_delete'.tr,
            style: const TextStyle(
              color: AppColors.cornsilk,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteBirthday();
              },
              child: Text(
                'delete'.tr,
                style: const TextStyle(
                  color: AppColors.cornsilk,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'cancel'.tr,
                style: const TextStyle(
                  color: AppColors.cornsilk,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future _deleteBirthday() async {
    await _cubit.removeBirthday(widget.birthday);
    Navigator.pop(context);
  }

  Future _updateBirthday() async {
    if (_nameController.text.isNotEmpty) {
      widget.birthday.personName = _nameController.text;
      widget.birthday.note = _noteController.text;
      await _cubit.updateBirthday(widget.birthday);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('changes_are_saved_successfully'.tr),
          ),
        );

        Navigator.of(context).pop();
      }
    }
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.birthday.birthdayDate,
      firstDate: DateTime(0),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != widget.birthday.birthdayDate) {
      widget.birthday.birthdayDate =
          DateTime(_idkYear! ? 0 : picked.year, picked.month, picked.day);
      setState(() {});
    }
  }
}
