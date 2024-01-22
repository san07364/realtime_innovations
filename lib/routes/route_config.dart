import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:realtime_innovations/features/employee/view/employee_edit_screen.dart';

import '../features/employee/view/employee_create_screen.dart';
import '../features/employee/view/employee_list_screen.dart';
part 'route_config.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: "/",
          page: EmployeeListRoute.page,
        ),
        AutoRoute(
          path: EmployeeCreateScreen.id,
          page: EmployeeCreateRoute.page,
        ),
        AutoRoute(
          path: EmployeeUpdateScreen.id,
          page: EmployeeUpdateRoute.page,
        ),
      ];
}
