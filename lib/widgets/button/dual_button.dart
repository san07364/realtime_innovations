import 'package:flutter/material.dart';
import 'package:realtime_innovations/constants/color_constants.dart';
import 'package:realtime_innovations/utils/extentions/locale_extention.dart';

class DualButton extends StatelessWidget {
  const DualButton({super.key, this.onCancel, this.onSave});
  final void Function()? onCancel;
  final void Function()? onSave;

  @override
  Widget build(BuildContext context) {
    var locale = context.l10n;
    var textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onCancel,
          child: Container(
            height: 40,
            width: 70,
            decoration: BoxDecoration(
              color: ColorConstants.primaryAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                locale.cancel,
                style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, color: ColorConstants.primary),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: onSave,
          child: Container(
            height: 40,
            width: 70,
            decoration: BoxDecoration(
              color: ColorConstants.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                locale.save,
                style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, color: ColorConstants.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
