import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_service.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditBirthdayPage extends StatefulWidget {
  final BirthdayModel _birthday;

  const EditBirthdayPage({super.key, required BirthdayModel birthday})
      : _birthday = birthday;

  @override
  State createState() => _EditBirthdayPageState(birthday: _birthday);
}

class _EditBirthdayPageState extends State<EditBirthdayPage> {
  final BirthdayModel _birthday;

  final _birthdayService = BirthdayService();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool? _idkYear = true;
  String get _selectedDateDisplayString =>
      _idkYear! || _birthday.birthdayDate.year == 0
          ? DateFormat('dd MMMM').format(_birthday.birthdayDate)
          : DateFormat('dd MMMM y').format(_birthday.birthdayDate);

  _EditBirthdayPageState({required BirthdayModel birthday})
      : _birthday = birthday;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday.birthdayDate,
      firstDate: DateTime(0),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _birthday.birthdayDate) {
      _birthday.birthdayDate =
          DateTime(_idkYear! ? 0 : picked.year, picked.month, picked.day);
      setState(() {});
    }
  }

  @override
  void initState() {
    _nameController.text = _birthday.personName;
    _descriptionController.text = _birthday.note;
    _idkYear = _birthday.birthdayDate.year == 0;

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
        title: const Text(
          'Edit cakeday',
          style: TextStyle(
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
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.cornsilk,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.cornsilk,
                  ),
                ),
                labelStyle: TextStyle(
                  color: AppColors.cornsilk,
                ),
                labelText: 'Person name',
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
                    _birthday.birthdayDate = DateTime(
                        _idkYear! ? 0 : _birthday.birthdayDate.year,
                        _birthday.birthdayDate.month,
                        _birthday.birthdayDate.day);
                    setState(() {});
                  },
                ),
                const Text(
                  "I don't know year",
                  style: TextStyle(
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
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.cornsilk,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.cornsilk,
                  ),
                ),
                labelStyle: TextStyle(
                  color: AppColors.cornsilk,
                ),
                labelText: 'Some notes to not forget who it is :D',
              ),
            ),
            const SizedBox(height: 15.0),
            FloatingActionButton.extended(
              backgroundColor: AppColors.lion,
              label: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: AppColors.cornsilk,
                  ),
                ),
              ),
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await _birthdayService.updateBirthday(_birthday);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Changes are saved successfully'),
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

  _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.lion,
          title: const Text(
            'Are you sure?',
            style: TextStyle(
              color: AppColors.cornsilk,
            ),
          ),
          content: const Text(
            'You are going to delete this birthday. You can\'t undo this action.',
            style: TextStyle(
              color: AppColors.cornsilk,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBirthday();
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.cornsilk,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.cornsilk,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _deleteBirthday() {
    _birthdayService.deleteBirthday(_birthday);
    Navigator.pop(context);
  }
}
