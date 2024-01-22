import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:realtime_innovations/constants/asset_constants.dart';
import 'package:realtime_innovations/constants/color_constants.dart';
import 'package:realtime_innovations/features/employee/controller/employee_controller.dart';
import 'package:realtime_innovations/features/employee/view/components/employee_role_sheet.dart';
import 'package:realtime_innovations/utils/extentions/locale_extention.dart';
import 'package:realtime_innovations/widgets/date_picker/custom_date_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../helpers/date_helper.dart';
import '../../../helpers/toast_helper.dart';
import '../../../widgets/button/dual_button.dart';
import '../../../widgets/text_field/custom_text_field.dart';

@RoutePage()
class EmployeeCreateScreen extends StatefulWidget {
  static const String id = "/employee/create";
  const EmployeeCreateScreen({super.key});

  @override
  State<EmployeeCreateScreen> createState() => _EmployeeCreateScreenState();
}

class _EmployeeCreateScreenState extends State<EmployeeCreateScreen> {
  String? _employeeName;
  String? _role;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  final _controller = GetIt.I<EmployeeCubit>();

  @override
  Widget build(BuildContext context) {
    var locale = context.l10n;
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

    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        title: Text(locale.addEmployeeDetails),
        automaticallyImplyLeading: false,
      ),
      body: Column(
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SvgPicture.asset(
                              AssetConstants.briefcase,
                            ),
                          ),
                          hint: locale.selectRole,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.5),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                  if (_employeeName == null || _employeeName!.trim().isEmpty) {
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
                  _controller.createEmployee(
                    name: _employeeName!,
                    role: _role!,
                    startDate: _startDate,
                    endDate: _endDate,
                  );
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
      ),
    );
  }
}
