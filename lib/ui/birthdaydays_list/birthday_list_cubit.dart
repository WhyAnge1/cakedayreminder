import 'package:cakeday_reminder/abstractions/cubit/base_cubit.dart';
import 'package:cakeday_reminder/abstractions/cubit/base_state.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_model.dart';
import 'package:cakeday_reminder/business_logic/birthday/birthday_usecase.dart';
import 'package:cakeday_reminder/events/refresh_birthdays_event.dart';
import 'package:event_bus_plus/res/event_bus.dart';
import 'package:injectable/injectable.dart';

@injectable
class BirthdayListCubit extends BaseCubit {
  final BirthdayUseCase _birthdayUseCase;
  final EventBus _eventBus;

  BirthdayListCubit(this._birthdayUseCase, this._eventBus)
      : super(InitialState()) {
    _eventBus.on<RefreshBirthdaysEvent>().listen(_onRefreshBirthdaysEvent);
  }

  Future getData() async {
    emit(LoadingState());

    final data = await _birthdayUseCase.getGroupedBirthdays();

    emit(SuccessDataState<Map<DateTime, List<BirthdayModel>>>(data));
  }

  Future _onRefreshBirthdaysEvent(RefreshBirthdaysEvent event) async {
    await getData();
  }
}
