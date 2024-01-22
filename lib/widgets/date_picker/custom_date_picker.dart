import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:realtime_innovations/constants/asset_constants.dart';
import 'package:realtime_innovations/constants/color_constants.dart';
import 'package:realtime_innovations/utils/extentions/locale_extention.dart';
import 'package:table_calendar/table_calendar.dart';

import '../button/dual_button.dart';

enum _SelectionType { today, nextMonday, nextTuesday, afterOneWeek, noDate }

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  bool showNoDate = false,
  DateTime? firstDay,
  bool selectToday = false,
}) async {
  DateTime? selectedDate;
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: _TableCalendar(
        showNoDate: showNoDate,
        firstDay: firstDay,
        selectToday: selectToday,
        onSave: (date) {
          selectedDate = date;
        },
      ),
    ),
  );
  return selectedDate;
}

class _TableCalendar extends StatefulWidget {
  final bool showNoDate;
  final DateTime? firstDay;
  final bool selectToday;
  final void Function(DateTime? dateTime) onSave;
  const _TableCalendar(
      {required this.showNoDate,
      required this.onSave,
      this.firstDay,
      required this.selectToday});

  @override
  State<_TableCalendar> createState() => _TableCalendarState();
}

class _TableCalendarState extends State<_TableCalendar> {
  _SelectionType? _selectionType;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    if (widget.selectToday) {
      _selectionType = _SelectionType.today;
      _selectedDay = DateTime.now();
    }
    if (widget.showNoDate) {
      _selectionType = _SelectionType.noDate;
    }
    if (widget.firstDay != null) {
      _focusedDay = widget.firstDay!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var locale = context.l10n;
    var currentDate = DateTime.now();
    var footerText = "";
    var showToday = true;

    switch (_selectionType) {
      case _SelectionType.today:
        footerText = locale.today;
        break;
      case _SelectionType.noDate:
        footerText = locale.noDate;
      default:
        if (_selectedDay != null) {
          footerText = DateFormat("dd MMM yyyy").format(_selectedDay!);
        }
    }

    if (widget.firstDay != null) {
      if (widget.firstDay!.isAfter(DateTime.now())) {
        showToday = false;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 24,
        ),
        widget.showNoDate
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _headerButton(
                        label: locale.noDate,
                        type: _SelectionType.noDate,
                        onTap: () {
                          _selectedDay = null;
                          _focusedDay = widget.firstDay ?? DateTime.now();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    showToday
                        ? Expanded(
                            child: _headerButton(
                              label: locale.today,
                              type: _SelectionType.today,
                              onTap: () {
                                _selectedDay = DateTime.now();
                                _focusedDay = _selectedDay!;
                              },
                            ),
                          )
                        : const Spacer(),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _headerButton(
                            label: locale.today,
                            type: _SelectionType.today,
                            onTap: () {
                              _selectedDay = DateTime.now();
                              _focusedDay = _selectedDay!;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: _headerButton(
                            label: locale.nextMonday,
                            type: _SelectionType.nextMonday,
                            onTap: () {
                              DateTime currentDate = DateTime.now();
                              _selectedDay = currentDate.add(
                                Duration(
                                    days: (DateTime.monday -
                                            currentDate.weekday +
                                            7) %
                                        7),
                              );
                              _focusedDay = _selectedDay!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _headerButton(
                            label: locale.nextTuesday,
                            type: _SelectionType.nextTuesday,
                            onTap: () {
                              // Get the current date
                              DateTime currentDate = DateTime.now();

                              // Find the next Tuesday's date
                              _selectedDay = currentDate.add(
                                Duration(
                                    days: (DateTime.tuesday -
                                            currentDate.weekday +
                                            7) %
                                        7),
                              );
                              _focusedDay = _selectedDay!;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: _headerButton(
                            label: locale.afterWeek,
                            type: _SelectionType.afterOneWeek,
                            onTap: () {
                              // Get the current date
                              DateTime currentDate = DateTime.now();

                              // Calculate the date after one week
                              _selectedDay = currentDate.add(
                                const Duration(days: 7),
                              );
                              _focusedDay = _selectedDay!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 330,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: TableCalendar(
              rowHeight: 40,
              daysOfWeekHeight: 20,
              focusedDay: _focusedDay,
              firstDay: widget.firstDay ?? DateTime(currentDate.year - 100),
              lastDay: DateTime(currentDate.year + 100),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectionType = null;
                  });
                }
              },
              calendarBuilders: CalendarBuilders(
                outsideBuilder: (context, date, _) => const SizedBox(),
                disabledBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Text(
                      "${day.day}",
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: ColorConstants.borderGrey,
                      ),
                    ),
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Text(
                      "${day.day}",
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: ColorConstants.primary,
                          border: Border.all(color: ColorConstants.primary),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          "${day.day}",
                          style: textTheme.bodyMedium?.copyWith(
                              fontSize: 15, color: ColorConstants.white),
                        ),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorConstants.primary),
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          "${day.day}",
                          style: textTheme.bodyMedium?.copyWith(
                              fontSize: 15, color: ColorConstants.primary),
                        ),
                      ),
                    ),
                  );
                },
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: textTheme.bodyMedium!.copyWith(fontSize: 15),
                weekendStyle: textTheme.bodyMedium!.copyWith(fontSize: 15),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: textTheme.bodyMedium!.copyWith(fontSize: 15),
                selectedDecoration: const BoxDecoration(
                    color: ColorConstants.primary, shape: BoxShape.circle),
                todayDecoration: const BoxDecoration(
                    color: ColorConstants.primary, shape: BoxShape.circle),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                leftChevronIcon: SvgPicture.asset(AssetConstants.chevronLeft),
                rightChevronIcon: SvgPicture.asset(AssetConstants.chevronRight),
                titleTextStyle: textTheme.bodyLarge!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                leftChevronMargin: const EdgeInsets.only(left: 65),
                rightChevronMargin: const EdgeInsets.only(right: 65),
              ),
            ),
          ),
        ),
        const Divider(
          height: 0,
          thickness: 2,
          color: ColorConstants.divider,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AssetConstants.calendar),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    footerText,
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const Spacer(),
              DualButton(
                onCancel: () {
                  context.router.pop();
                },
                onSave: () async {
                  widget.onSave(_selectedDay);
                  context.router.pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerButton({
    required String label,
    required void Function()? onTap,
    required _SelectionType type,
  }) {
    var textTheme = Theme.of(context).textTheme;
    var isSelected = _selectionType == type;
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
        setState(() {
          _selectionType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isSelected
              ? ColorConstants.primary
              : ColorConstants.primaryAccent,
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: isSelected ? ColorConstants.white : ColorConstants.primary,
            ),
          ),
        ),
      ),
    );
  }
}
