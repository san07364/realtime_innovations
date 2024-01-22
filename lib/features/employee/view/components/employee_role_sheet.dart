import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:realtime_innovations/utils/extentions/locale_extention.dart';

import '../../../../constants/color_constants.dart';

Future<String?> showEmployeeRoleSheet({required BuildContext context}) async {
  String? role;
  var locale = context.l10n;
  var textTheme = Theme.of(context).textTheme;
  List<String> roles = [];
  roles.addAll([
    locale.productDesigner,
    locale.flutterDeveloper,
    locale.qaTester,
    locale.productOwner
  ]);
  FocusScope.of(context).unfocus();
  await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: roles.length,
          itemBuilder: (context, index) {
            return Center(
                child: InkWell(
              onTap: () {
                context.router.pop();
                role = roles[index];
              },
              child: SizedBox(
                height: 52,
                child: Center(
                  child: Text(
                    roles[index],
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ));
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 0,
              thickness: 1,
              color: ColorConstants.divider,
            );
          },
        );
      });
  return role;
}
