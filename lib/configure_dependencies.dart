import 'package:cakeday_reminder/business_logic/constants/app_constants.dart';
import 'package:cakeday_reminder/business_logic/database/database.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'configure_dependencies.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future configureDependencies() async {
  var database = await $FloorAppDatabase
      .databaseBuilder(AppConstants.dataBaseName)
      .build();
  getIt.registerSingleton<AppDatabase>(database);
  getIt.registerSingleton<EventBus>(EventBus());

  getIt.init();
}
