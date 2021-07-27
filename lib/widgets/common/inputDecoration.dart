import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart';

class InputStyleDecoration extends StatelessWidget {
  final Widget inputChild;
  final bool isLastChild;
  final Widget extendsWidget;
  final String title;

  InputStyleDecoration(this.title, this.inputChild,
      {Key key, this.extendsWidget, this.isLastChild = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          border: !isLastChild
              ? Border(
                  bottom: BorderSide(
                      // 设置单侧边框的样式
                      color: AppTheme.backgroundDefaultColor,
                      width: 1,
                      style: BorderStyle.solid))
              : null),
      child: Row(children: [
        Text(
          title,
          style: TextStyle(
              color: AppTheme.titleColor, fontSize: AppTheme.fontSizeSmall),
        ),
        Expanded(child: inputChild),
        extendsWidget ?? Container()
      ]),
    );
  }
}
