import 'dart:io';

import 'package:demo7_pro/config/theme.dart';
import 'package:demo7_pro/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 针对不同平台展示对应的 actionSheet 组件
///
/// AppBottomSheet _sheet = AppBottomSheet(
///   context,
///   title: '请选择',
///   checked: '已选择的值',
///   actions: [
///       AppActionSheetRow('选项一', value: 1),
///       AppActionSheetRow('选项二', value: 2),
///   ],
/// );
/// var _value = await _sheet.open();
///
class AppBottomSheet {
  /// 是否为 Android 平台
  bool isAndroid = Platform.isAndroid;

  /// 是否为 ios 平台
  bool isIos = Platform.isIOS;

  /// BuildContext
  final BuildContext context;

  /// 标题
  final String title;

  /// 消息
  final String message;

  /// 操作项
  final List<AppActionSheetRow> actions;

  /// 已选择条目
  final dynamic checked;

  /// 实例化
  AppBottomSheet(
    this.context, {
    @required this.actions,
    this.title,
    this.message,
    this.checked,
  });

  /// 打开
  Future<dynamic> open() {
    if (isIos) return withIOS();
    return withAndroid();
  }

  /// 打开 android 平台样式
  Future<dynamic> withAndroid() async {
    var value = await showModalBottomSheet(
      context: context,
      builder: _android,
      isDismissible: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.gutter),
        ),
      ),
      // isScrollControlled: true,
    );
    return value;
  }

  /// 打开 iOS 平台
  Future<dynamic> withIOS() {
    return showCupertinoModalPopup(
      context: context,
      builder: _ios,
    );
  }

  // 构建 Android 平台的组件样式
  Widget _android(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(height: AppTheme.gutter),
          titleText,
          if (title != null) SizedBox(height: AppTheme.gutter),
          messageText,
          if (message != null) SizedBox(height: AppTheme.gutter),
          actionsList,
          cancel,
        ],
      ),
    );
  }

  Widget get titleText {
    if (title == null) return Container();
    return Container(
      padding: EdgeInsets.all(AppTheme.gutter),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppTheme.fontSizeTitle,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget get messageText {
    if (message == null) return Container();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        message,
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  Widget get actionsList {
    return LimitedBox(
      maxHeight: MediaQuery.of(context).size.height * 0.3,
      child: ListView(
        shrinkWrap: true,
        children: List<Widget>.generate(
          actions.length,
          (int index) => actionRow(actions[index]),
        ),
      ),
    );
  }

  Widget actionRow(AppActionSheetRow row) {
    return InkWell(
      onTap: () {
        handleChangeItem(row);
      },
      splashColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: AppTheme.gutter,
          horizontal: AppTheme.gutter,
        ),
        color: checked == (row.value ?? row.label)
            ? AppTheme.borderColor.withOpacity(0.3)
            : Colors.transparent,
        child: Row(
          children: [
            Container(width: 32),
            Expanded(
              child: Text(
                row.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: row.disabled == true
                      ? AppTheme.lightTextColor
                      : AppTheme.textColor,
                  fontSize: AppTheme.fontSizeBase,
                  fontWeight: checked == (row.value ?? row.label)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            Container(
              width: 32,
              child: checked == (row.value ?? row.label)
                  ? Icon(
                      Icons.check,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget get cancel {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(AppTheme.gutter),
      child: AppBasedButton(
        text: '取消',
        color: AppTheme.borderColor,
        textColor: AppTheme.secondTextColor,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// 构建 IOS 平台的组件样式
  Widget _ios(BuildContext context) {
    return CupertinoActionSheet(
      title: title != null ? Text(title) : null,
      message: message != null ? Text(message) : null,
      actions: actions != null && actions.length > 0
          ? List<CupertinoActionSheetAction>.generate(actions.length, (index) {
              // 获取条目
              AppActionSheetRow _row = actions[index];
              // 创建条目
              return CupertinoActionSheetAction(
                child: Text(
                  _row.label,
                  style: TextStyle(
                    color: _row.disabled == true ? Colors.grey : Colors.blue,
                  ),
                ),
                isDefaultAction: checked == (_row.value ?? _row.label),
                onPressed: () {
                  handleChangeItem(_row);
                },
              );
            })
          : [],
      cancelButton: CupertinoActionSheetAction(
        child: Text('取消'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// 选择回调
  void handleChangeItem(AppActionSheetRow row) {
    if (row.disabled) return;
    Navigator.pop(context, row.value ?? row.label);
  }
}

/// actionSheet 配置条目
class AppActionSheetRow {
  /// 值
  final dynamic value;

  /// 展示名称
  final String label;

  /// 是否已禁用
  final bool disabled;

  /// 自定义样式
  final TextStyle style;

  /// actionSheet 配置条目
  AppActionSheetRow(
    this.label, {
    this.value,
    this.disabled: false,
    this.style,
  });
}
