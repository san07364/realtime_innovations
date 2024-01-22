import 'package:get_it/get_it.dart';
import 'package:realtime_innovations/features/employee/model/employee.dart';

import '../../../services/local_database_service.dart';

class EmployeeRepository {
  final String table = "employees";
  final _db = GetIt.I<LocalDatabaseService>();

  Future<void> createEmployee({required Employee employee}) async {
    await _db.create(table: table, data: employee.toJson());
  }

  Future<List<Employee>> getEmployeesList() async {
    var data = await _db.find(table: table, orderBy: 'startDate DESC');
    return _employeeListFromMap(data: data);
  }

  List<Employee> _employeeListFromMap(
      {required List<Map<String, Object?>> data}) {
    var employeeList = <Employee>[];
    for (var employee in data) {
      employeeList.add(Employee.fromJson(employee));
    }
    return employeeList;
  }

  Future<void> deleteEmployee({required int employeeId}) async {
    await _db.deleteById(table: table, id: employeeId);
  }

  Future<Employee?> getEmployeeById({required int employeeId}) async {
    var data = await _db.findById(table: table, id: employeeId);
    if (data.isNotEmpty) {
      return Employee.fromJson(data.first);
    }
    return null;
  }

  Future<void> updateEmployee({required Employee employee}) async {
    await _db.updateById(
      table: table,
      id: employee.id!,
      data: employee.toJson(),
    );
  }
}
