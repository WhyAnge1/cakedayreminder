import 'package:cakeday_reminder/abstractions/cubit/base_cubit.dart';
import 'package:cakeday_reminder/abstractions/cubit/base_state.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_usecase.dart';
import 'package:cakeday_reminder/events/refresh_birthdays_event.dart';
import 'package:event_bus_plus/res/event_bus.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateBirthdayCubit extends BaseCubit {
  final BirthdayUseCase _birthdayUseCase;
  final EventBus _eventBus;

  CreateBirthdayCubit(this._birthdayUseCase, this._eventBus)
      : super(InitialState());

  Future createBirthday(BirthdayModel model) async {
    emit(LoadingState());

    await _birthdayUseCase.addBirthday(model);

    _eventBus.fire(RefreshBirthdaysEvent());

    emit(SuccessState());
  }
}
