import 'dart:io';

import 'package:cakeday_reminder/abstractions/base_error.dart';
import 'package:cakeday_reminder/abstractions/cubit/base_cubit.dart';
import 'package:cakeday_reminder/abstractions/cubit/base_state.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_usecase.dart';
import 'package:cakeday_reminder/business_logic/export/export_usecase.dart';
import 'package:cakeday_reminder/business_logic/import/import_usecase.dart';
import 'package:cakeday_reminder/business_logic/notifications/notifications_usecase.dart';
import 'package:cakeday_reminder/events/refresh_birthdays_event.dart';
import 'package:event_bus_plus/res/event_bus.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends BaseCubit {
  final ImportUseCase _importUseCase;
  final ExportUseCase _exportUseCase;
  final NotificationsUseCase _notificationsUseCase;
  final BirthdayUseCase _birthdayUseCase;
  final EventBus _eventBus;

  ProfileCubit(this._importUseCase, this._exportUseCase,
      this._notificationsUseCase, this._birthdayUseCase, this._eventBus)
      : super(InitialState());

  Future deleteAllBirthdays() async {
    emit(LoadingState());

    final allBirthdays = await _birthdayUseCase.getAllBirthdays();
    for (final birthday in allBirthdays) {
      await _birthdayUseCase.removeBirthday(birthday);
    }
    _notificationsUseCase.cancelAllNotifications();

    _eventBus.fire(RefreshBirthdaysEvent());

    emit(SuccessState());
  }

  Future reloadNotifications() async {
    emit(LoadingState());

    _notificationsUseCase.cancelAllNotifications();

    final groupedBirthdays = await _birthdayUseCase.getGroupedBirthdays();

    for (final date in groupedBirthdays.keys) {
      await _birthdayUseCase.setupNewNotificationForBirthdayByDate(
          date, groupedBirthdays[date]!);
    }

    emit(SuccessState());
  }

  Future importBirthdaysFromFile(String filePath) async {
    emit(LoadingState());
    var importedBirthdays =
        await _importUseCase.importBirthdaysFromExel(File(filePath));

    if (importedBirthdays.isNotEmpty) {
      await _birthdayUseCase.addBirthdays(importedBirthdays);

      _eventBus.fire(RefreshBirthdaysEvent());

      emit(SuccessDataState('cakedays_imported_successfully'));
    } else {
      emit(FailureState(BaseError(message: 'failed_to_import_cakedays')));
    }
  }

  Future exportBirthdaysAsXml() async {
    emit(LoadingState());
    final birthdays = await _birthdayUseCase.getAllBirthdays();
    final result = await _exportUseCase.exportBirthdaysToXml(birthdays);

    if (result) {
      emit(SuccessState());
    } else {
      emit(FailureState(BaseError(message: 'failed_to_export_cakedays')));
    }
  }
}
