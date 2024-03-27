import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_provider.dart';
import 'package:cakeday_reminder/extensions/datetime_extensions.dart';
import 'package:cakeday_reminder/ui/birthdaydays_list/birthday_cell.dart';
import 'package:cakeday_reminder/ui/edit_birthday/edit_birthday_page.dart';
import 'package:cakeday_reminder/ui/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BirthdayListPage extends StatefulWidget {
  const BirthdayListPage({super.key});

  @override
  State<BirthdayListPage> createState() => _BirthdayListPageState();
}

class _BirthdayListPageState extends State<BirthdayListPage> {
  @override
  void initState() {
    context.read<BirthdayProvider>().refreshBirthdays();

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
          'all_cakedays'.tr,
          style: const TextStyle(
            color: AppColors.cornsilk,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Consumer<BirthdayProvider>(
          builder: (context, provider, child) => RefreshIndicator(
            onRefresh: () async => await provider.refreshBirthdays(),
            child: Column(
              children: [
                const SizedBox(height: 15),
                provider.birthdayList.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'no_birthdays_yet'.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.cornsilk,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 15),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemCount: provider.birthdayList.length,
                          itemBuilder: (context, index) {
                            final modelKey =
                                provider.birthdayList.keys.elementAt(index);

                            return _constructBirthdayGroupedCell(
                                modelKey, provider.birthdayList[modelKey]!);
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _constructBirthdayGroupedCell(
      DateTime date, List<BirthdayModel> dateBirthdays) {
    final isTodayIsBirthday = date.isToday();

    return Column(
      children: [
        isTodayIsBirthday
            ? GradientAnimationText(
                text: Text(
                  _convertDateToString(date),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.cornsilk,
                  ),
                ),
                colors: const [
                  AppColors.princetonOrange,
                  AppColors.icterine,
                ],
                duration: const Duration(seconds: 2),
              )
            : Text(
                _convertDateToString(date),
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.cornsilk,
                ),
              ),
        const SizedBox(height: 15),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemCount: dateBirthdays.length,
          itemBuilder: (context, index) {
            var model = dateBirthdays[index];

            return _constructBirthdayCell(model, isTodayIsBirthday);
          },
        ),
      ],
    );
  }

  Widget _constructBirthdayCell(BirthdayModel model, bool isTodayIsBirthday) {
    return BirthdayCell(
      model: model,
      onTap: () async => await _onCellTapped(model),
      isBirthdayCell: isTodayIsBirthday,
    );
  }

  String _convertDateToString(DateTime dateToConvert) {
    var convertedDate = DateFormat('d MMMM').format(dateToConvert);

    if (dateToConvert.isToday()) {
      return 'today'.tr;
    }

    if (dateToConvert.isTomorrow()) {
      return 'tomorrow'.tr;
    }

    if (dateToConvert.isInSevenDays()) {
      return DateFormat('EEEE, d MMMM').format(dateToConvert);
    }

    return convertedDate;
  }

  Future _onCellTapped(BirthdayModel model) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBirthdayPage(
          birthday: model,
        ),
      ),
    );
  }
}
