import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart' show AppTheme;

/// input
class InputForm extends StatelessWidget {
  final Function onTap;
  final String hintStr;
  final int maxLength;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function validatorFn;
  final Function onChange;

  InputForm({
    Key key,
    @required this.controller,
    @required this.validatorFn,
    @required this.onChange,
    this.onTap,
    this.hintStr,
    this.maxLength,
    this.readOnly,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: maxLength,
        textAlign: TextAlign.right,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          counterText: "",
          // 不显示输入框最大字数统计
          border: InputBorder.none,
          hintText: hintStr,
          hintStyle: TextStyle(
              color: AppTheme.placeholderColor,
              fontSize: AppTheme.fontSizeSmall),
          hintTextDirection: TextDirection.rtl,
        ),
        validator: validatorFn,
        onTap: onTap,
        onChanged: onChange);
  }
}
