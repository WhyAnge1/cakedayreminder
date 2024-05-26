import 'package:cakeday_reminder/business_logic/database/database.dart';
import 'package:cakeday_reminder/configure_dependencies.dart';

abstract class BaseUseCase {
  late AppDatabase database = getIt<AppDatabase>();
}
