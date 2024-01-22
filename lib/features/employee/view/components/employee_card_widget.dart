part of '../employee_list_screen.dart';

class _EmployeeCard extends StatelessWidget {
  final Employee employee;
  final BuildContext scaffoldContext;
  const _EmployeeCard({required this.employee, required this.scaffoldContext});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var locale = context.l10n;
    String? fromDate;
    String? toDate;
    fromDate = DateFormat("dd MMM, yyyy").format(employee.startDate);
    if (employee.endDate != null) {
      toDate = DateFormat("dd MMM, yyyy").format(employee.endDate!);
    }
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        ScaffoldMessenger.of(scaffoldContext).clearSnackBars();
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            content: Row(
              children: [
                Expanded(
                  child: Text(
                    locale.employeeDataDeleted,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontSize: 15, color: ColorConstants.white),
                  ),
                ),
                InkWell(
                  onTap: () {
                    GetIt.I<EmployeeCubit>().createEmployee(
                      name: employee.name,
                      role: employee.role,
                      startDate: employee.startDate,
                      endDate: employee.endDate,
                    );
                    ScaffoldMessenger.of(scaffoldContext).clearSnackBars();
                  },
                  child: Text(
                    locale.undo,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontSize: 15, color: ColorConstants.primary),
                  ),
                ),
              ],
            ),
          ),
        );
        GetIt.I<EmployeeCubit>().deleteEmployee(employeeId: employee.id);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: ColorConstants.delete,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 17),
            child: SvgPicture.asset(AssetConstants.delete),
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          context.router.pushNamed(
            EmployeeUpdateScreen.getPath(employeeId: "${employee.id}"),
          );
        },
        child: Container(
          color: ColorConstants.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(),
              Text(
                employee.name,
                style:
                    textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                employee.role,
                style: textTheme.bodyMedium
                    ?.copyWith(color: ColorConstants.labelGrey),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                toDate == null
                    ? "${locale.from} $fromDate"
                    : "$fromDate - $toDate",
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: ColorConstants.labelGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
