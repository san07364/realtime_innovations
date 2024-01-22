import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:realtime_innovations/constants/asset_constants.dart';
import 'package:realtime_innovations/constants/color_constants.dart';
import 'package:realtime_innovations/features/employee/controller/employee_controller.dart';
import 'package:realtime_innovations/features/employee/model/employee.dart';
import 'package:realtime_innovations/features/employee/view/employee_edit_screen.dart';
import 'package:realtime_innovations/utils/extentions/locale_extention.dart';

import '../controller/employee_state.dart';
import 'employee_create_screen.dart';

part './components/no_employee_widget.dart';
part './components/employee_card_widget.dart';

@RoutePage()
class EmployeeListScreen extends StatefulWidget {
  static const id = "/employee/list";
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final _controller = GetIt.I<EmployeeCubit>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller.getEmployee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = context.l10n;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(locale.employeeList),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          onPressed: () {
            context.router.pushNamed(EmployeeCreateScreen.id);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.add),
        ),
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        bloc: _controller,
        builder: (context, state) {
          if (state.currentEmployeeList.isEmpty &&
              state.pastEmployeeList.isEmpty) {
            return const _NoEmployees();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.currentEmployeeList.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      locale.currentEmployees,
                      style: textTheme.bodyLarge?.copyWith(
                        color: ColorConstants.primary,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: state.currentEmployeeList.length,
                    itemBuilder: (context, index) {
                      return _EmployeeCard(
                        employee: state.currentEmployeeList[index],
                        scaffoldContext: _scaffoldKey.currentContext!,
                      );
                    },
                  ),
                ],
                if (state.pastEmployeeList.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      locale.previousEmployees,
                      style: textTheme.bodyLarge?.copyWith(
                        color: ColorConstants.primary,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: state.pastEmployeeList.length,
                    itemBuilder: (context, index) {
                      return _EmployeeCard(
                        employee: state.pastEmployeeList[index],
                        scaffoldContext: _scaffoldKey.currentContext!,
                      );
                    },
                  ),
                ],
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    locale.swipeLeftToDelete,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorConstants.labelGrey,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
