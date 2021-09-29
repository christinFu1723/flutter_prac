import 'package:demo7_pro/config/theme.dart';
import 'package:demo7_pro/utils/app.dart';
import 'package:demo7_pro/route/route_util.dart' show pop;
import 'package:demo7_pro/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 通用确认弹窗
class AppConfirm extends StatelessWidget {
  /// 标题
  final String title;

  /// 副标题
  final String titleSub;

  /// 内容
  final Widget content;

  /// 操作按钮
  /// 如果未设置，则使用默认的按钮
  final List<Widget> actions;

  /// 取消文本
  final String cancelText;

  /// 取消文本的颜色
  final Color cancelTextColor;

  /// 确定文本
  final String confirmText;

  /// 确定文本的颜色
  final Color confirmTextColor;

  /// 取消按钮时执行的回调
  final VoidCallback onCancel;

  /// 确定按钮时执行的回调
  final VoidCallback onConfirm;

  static TextStyle contentTextStyle = TextStyle(
    fontSize: AppTheme.fontSizeBase - 3,
    color: AppTheme.secondTextColor,
    height: 1.7,
  );

  /// 自定义弹窗
  AppConfirm({
    this.title,
    this.titleSub,
    @required this.content,
    this.actions,
    this.confirmText,
    this.confirmTextColor,
    this.cancelText,
    this.cancelTextColor,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.gutter),
      ),
      child: IntrinsicWidth(
        stepWidth: 56,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _createTitle(),
              Container(
                constraints: const BoxConstraints(maxHeight: 400.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: AppTheme.gutter,
                    horizontal: AppTheme.gutter * 2,
                  ),
                  child: content,
                ),
              ),
              Container(
                padding: EdgeInsets.all(AppTheme.gutter),
                child: _defaultOptions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 标题栏
  Widget _createTitle() {
    List<Widget> _child = [];

    if (title != null) {
      _child.add(Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          title.toString(),
          style: TextStyle(
            fontSize: AppTheme.fontSizeTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }

    if (titleSub != null) {
      _child.add(Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          titleSub.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppTheme.fontSizeBase - 3,
            color: AppTheme.secondTextColor,
          ),
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(children: _child),
    );
  }

  // 默认操作按钮
  Widget _defaultOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppBasedButton(
            text: cancelText ?? '取消',
            color: AppTheme.borderColor.withOpacity(0.5),
            showShadow: false,
            textColor: AppTheme.secondTextColor,
            onPressed: () {
              pop(context, result: false);
            },
          ),
        ),
        SizedBox(width: AppTheme.gutter),
        Expanded(
          child: AppBasedButton(
            text: confirmText ?? '确认',
            color: AppTheme.primaryColor,
            onPressed: () {
              pop(context, result: true);
            },
          ),
        ),
      ],
    );
  }
}
