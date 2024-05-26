import 'package:cakeday_reminder/abstractions/cubit/base_cubit.dart';
import 'package:cakeday_reminder/abstractions/cubit/base_state.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_usecase.dart';
import 'package:cakeday_reminder/events/refresh_birthdays_event.dart';
import 'package:event_bus_plus/res/event_bus.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditBirthdayCubit extends BaseCubit {
  final BirthdayUseCase _birthdayUseCase;
  final EventBus _eventBus;

  EditBirthdayCubit(this._birthdayUseCase, this._eventBus)
      : super(InitialState());

  Future updateBirthday(BirthdayModel model) async {
    emit(LoadingState());

    await _birthdayUseCase.updateBirthday(model);

    _eventBus.fire(RefreshBirthdaysEvent());

    emit(SuccessState());
  }

  Future removeBirthday(BirthdayModel model) async {
    emit(LoadingState());

    await _birthdayUseCase.removeBirthday(model);

    _eventBus.fire(RefreshBirthdaysEvent());

    emit(SuccessState());
  }
}
