import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart';

class TitleSpan extends StatelessWidget {
  final String title;

  TitleSpan({Key key, this.title});

  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 16,
          decoration: BoxDecoration(
              color: Color(0xff00b3bf), borderRadius: BorderRadius.circular(3)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: TextStyle(
                fontSize: AppTheme.fontSizeSecond,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor),
          ),
        )
      ],
    );
  }
}
