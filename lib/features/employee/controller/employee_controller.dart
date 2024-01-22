import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_innovations/features/employee/model/employee.dart';
import 'package:realtime_innovations/features/employee/repository/employee_repository.dart';

import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final _repo = EmployeeRepository();
  EmployeeCubit() : super(EmployeeState());

  Future<void> createEmployee({
    required String name,
    required String role,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    try {
      await _repo.createEmployee(
        employee: Employee(
          name: name,
          role: role,
          startDate: startDate,
          endDate: endDate,
        ),
      );
      await getEmployee();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getEmployee() async {
    try {
      var currentEmployee = <Employee>[];
      var pastEmployee = <Employee>[];
      var employeeList = await _repo.getEmployeesList();
      for (var employee in employeeList) {
        if (employee.endDate == null) {
          currentEmployee.add(employee);
        } else {
          pastEmployee.add(employee);
        }
      }
      emit(
        state.copyWith(
          currentEmployeeList: currentEmployee,
          pastEmployeeList: pastEmployee,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteEmployee({required int? employeeId}) async {
    if (employeeId == null) return;
    try {
      await _repo.deleteEmployee(employeeId: employeeId);
      if (state.currentEmployeeList.length == 1 ||
          state.pastEmployeeList.length == 1) {
        await getEmployee();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateEmployee({required Employee employee}) async {
    try {
      await _repo.updateEmployee(employee: employee);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getEmployeeById({required int employeeId}) async {
    try {
      var employee = await _repo.getEmployeeById(employeeId: employeeId);
      emit(
        state.copyWith(updateEmployee: employee),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
