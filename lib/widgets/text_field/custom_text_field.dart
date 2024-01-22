import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.prefixIcon,
    required this.hint,
    this.suffixIcon,
    this.initialText,
    this.onChanged,
  });

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hint;
  final String? initialText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 40,
      child: TextFormField(
        initialValue: initialText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.zero,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.borderGrey),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.borderGrey),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.borderGrey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.borderGrey),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.borderGrey),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.borderGrey),
          ),
          hintStyle: textTheme.bodyMedium
              ?.copyWith(color: ColorConstants.labelGrey, fontSize: 16),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelStyle: textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
