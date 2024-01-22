import 'package:get_it/get_it.dart';
import 'package:realtime_innovations/features/employee/controller/employee_controller.dart';

import 'local_database_service.dart';

class DependencyInjector {
  static Future<void> init() async {
    GetIt.I.registerSingleton(LocalDatabaseService());
    GetIt.I.registerSingleton(EmployeeCubit());
  }
}
