import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:realtime_innovations/constants/asset_constants.dart';
import 'package:realtime_innovations/constants/color_constants.dart';
import 'package:realtime_innovations/features/employee/controller/employee_controller.dart';
import 'package:realtime_innovations/features/employee/controller/employee_state.dart';
import 'package:realtime_innovations/features/employee/model/employee.dart';
import 'package:realtime_innovations/helpers/toast_helper.dart';
import 'package:realtime_innovations/utils/extentions/locale_extention.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../helpers/date_helper.dart';
import '../../../widgets/button/dual_button.dart';
import '../../../widgets/date_picker/custom_date_picker.dart';
import '../../../widgets/text_field/custom_text_field.dart';
import 'components/employee_role_sheet.dart';

@RoutePage()
class EmployeeUpdateScreen extends StatefulWidget {
  static const String id = "/employee/update/:employeeId";
  static String getPath({required String employeeId}) =>
      "/employee/update/$employeeId";
  const EmployeeUpdateScreen({
    super.key,
    @PathParam("employeeId") required this.employeeId,
  });
  final String employeeId;

  @override
  State<EmployeeUpdateScreen> createState() => _EmployeeUpdateScreenState();
}

class _EmployeeUpdateScreenState extends State<EmployeeUpdateScreen> {
  String? _employeeName;
  String? _role;
  DateTime? _startDate;
  DateTime? _endDate;
  late final int _employeeId;
  final _controller = EmployeeCubit();
  bool isDataAssigned = false;

  @override
  void initState() {
    _employeeId = int.parse(widget.employeeId);
    _controller.getEmployeeById(employeeId: _employeeId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = context.l10n;
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        title: Text(locale.editEmployeeDetails),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              var router = context.router;
              await _controller.deleteEmployee(employeeId: _employeeId);
              GetIt.I<EmployeeCubit>().getEmployee();
              router.pop();
            },
            icon: SvgPicture.asset(AssetConstants.delete),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => _controller,
        child: BlocBuilder<EmployeeCubit, EmployeeState>(
          builder: (context, state) {
            if (state.updateEmployee == null) return const SizedBox();
            if (!isDataAssigned) {
              _employeeName ??= state.updateEmployee?.name;
              _role ??= state.updateEmployee?.role;
              _startDate ??= state.updateEmployee?.startDate;
              _endDate ??= state.updateEmployee?.endDate;
              isDataAssigned = true;
            }

            var startDayLabel = "";
            var endDayLabel = "";

            if (isSameDay(_startDate, DateTime.now())) {
              startDayLabel = locale.today;
            } else {
              startDayLabel = DateHelper.getFormattedDate(dateTime: _startDate);
            }

            if (_endDate == null) {
              endDayLabel = locale.noDate;
            } else {
              endDayLabel = DateHelper.getFormattedDate(dateTime: _endDate);
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          CustomTextField(
                            initialText: _employeeName,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: SvgPicture.asset(
                                AssetConstants.profile,
                              ),
                            ),
                            hint: locale.employeeName,
                            onChanged: (value) {
                              _employeeName = value;
                            },
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          InkWell(
                            onTap: () async {
                              var role =
                                  await showEmployeeRoleSheet(context: context);
                              if (role != null) {
                                _role = role;
                                setState(() {});
                              }
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                key: Key(_role ?? ""),
                                initialText: _role,
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: SvgPicture.asset(
                                    AssetConstants.briefcase,
                                  ),
                                ),
                                hint: locale.selectRole,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.5),
                                  child: SvgPicture.asset(
                                    AssetConstants.down,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    var date = await showCustomDatePicker(
                                        context: context, selectToday: true);
                                    if (date == null) return;
                                    _startDate = date;
                                    _endDate = null;
                                    setState(() {});
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      key: Key(startDayLabel),
                                      initialText: startDayLabel,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: SvgPicture.asset(
                                          AssetConstants.calendar,
                                        ),
                                      ),
                                      hint: startDayLabel,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              SvgPicture.asset(AssetConstants.next),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    var date = await showCustomDatePicker(
                                      context: context,
                                      showNoDate: true,
                                      firstDay: _startDate,
                                    );
                                    _endDate = date;
                                    setState(() {});
                                  },
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      key: Key(endDayLabel),
                                      initialText:
                                          _endDate == null ? null : endDayLabel,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: SvgPicture.asset(
                                          AssetConstants.calendar,
                                        ),
                                      ),
                                      hint: endDayLabel,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 2,
                  color: ColorConstants.divider,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DualButton(
                      onCancel: () {
                        context.router.pop();
                      },
                      onSave: () async {
                        if (_employeeName == null ||
                            _employeeName!.trim().isEmpty) {
                          ToastHelper.showToast(
                            context: context,
                            message: locale.nameRequired,
                          );
                          return;
                        }
                        if (_role == null) {
                          ToastHelper.showToast(
                            context: context,
                            message: locale.roleRequired,
                          );
                          return;
                        }
                        _controller.updateEmployee(
                          employee: Employee(
                            id: _employeeId,
                            name: _employeeName!,
                            role: _role!,
                            startDate: _startDate!,
                            endDate: _endDate,
                          ),
                        );
                        GetIt.I<EmployeeCubit>().getEmployee();
                        context.router.pop();
                      },
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
