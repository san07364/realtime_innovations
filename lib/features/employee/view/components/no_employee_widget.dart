part of '../employee_list_screen.dart';

class _NoEmployees extends StatelessWidget {
  const _NoEmployees();

  @override
  Widget build(BuildContext context) {
    var locale = context.l10n;
    var textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AssetConstants.noData,
            height: 200,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            locale.recordNotFound,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
