import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/employee.dart';

part 'employee_state.freezed.dart';
part 'employee_state.g.dart';

@freezed
class EmployeeState with _$EmployeeState {
  factory EmployeeState({
    @Default([]) List<Employee> currentEmployeeList,
    @Default([]) List<Employee> pastEmployeeList,
    Employee? updateEmployee,
  }) = _EmployeeState;

  factory EmployeeState.fromJson(Map<String, dynamic> json) =>
      _$EmployeeStateFromJson(json);
}
