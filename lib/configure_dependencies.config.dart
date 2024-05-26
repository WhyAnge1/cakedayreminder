// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cakeday_reminder/business_logic/birthday/birthday_usecase.dart'
    as _i6;
import 'package:cakeday_reminder/business_logic/export/export_usecase.dart'
    as _i3;
import 'package:cakeday_reminder/business_logic/import/import_usecase.dart'
    as _i4;
import 'package:cakeday_reminder/business_logic/notifications/notifications_usecase.dart'
    as _i5;
import 'package:cakeday_reminder/ui/birthdaydays_list/birthday_list_cubit.dart'
    as _i11;
import 'package:cakeday_reminder/ui/create_birthday/create_birthday_cubit.dart'
    as _i9;
import 'package:cakeday_reminder/ui/edit_birthday/edit_birthday_cubit.dart'
    as _i10;
import 'package:cakeday_reminder/ui/profile/profile_cubit.dart' as _i7;
import 'package:event_bus_plus/res/event_bus.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.ExportUseCase>(() => _i3.ExportUseCase());
    gh.factory<_i4.ImportUseCase>(() => _i4.ImportUseCase());
    gh.factory<_i5.NotificationsUseCase>(() => _i5.NotificationsUseCase());
    gh.factory<_i6.BirthdayUseCase>(
        () => _i6.BirthdayUseCase(gh<_i5.NotificationsUseCase>()));
    gh.factory<_i7.ProfileCubit>(() => _i7.ProfileCubit(
          gh<_i4.ImportUseCase>(),
          gh<_i3.ExportUseCase>(),
          gh<_i5.NotificationsUseCase>(),
          gh<_i6.BirthdayUseCase>(),
          gh<_i8.EventBus>(),
        ));
    gh.factory<_i9.CreateBirthdayCubit>(() => _i9.CreateBirthdayCubit(
          gh<_i6.BirthdayUseCase>(),
          gh<_i8.EventBus>(),
        ));
    gh.factory<_i10.EditBirthdayCubit>(() => _i10.EditBirthdayCubit(
          gh<_i6.BirthdayUseCase>(),
          gh<_i8.EventBus>(),
        ));
    gh.factory<_i11.BirthdayListCubit>(() => _i11.BirthdayListCubit(
          gh<_i6.BirthdayUseCase>(),
          gh<_i8.EventBus>(),
        ));
    return this;
  }
}
