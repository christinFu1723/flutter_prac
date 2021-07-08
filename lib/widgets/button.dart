import 'dart:math';

import 'package:demo7_pro/config/theme.dart';
import 'package:flutter/material.dart';

/// 按钮尺寸
enum AppBasedButtonSize {
  /// 极小尺寸，高度约为 24
  mini,

  /// 较小尺寸，高度约为 32
  small,

  /// 常规尺寸，高度约为 44
  base,

  /// 较大尺寸，高度约为 56
  large,

  /// 较大尺寸，高度约为 80
  big,
}

/// 通用按钮
class AppBasedButton extends StatelessWidget {
  /// 按钮文本
  final String text;

  /// 按钮内容组件
  ///
  /// 指定了 child 时，text 将被忽略
  final Widget child;

  /// 尺寸
  final AppBasedButtonSize size;

  /// 颜色
  final Color color;

  /// 是否为边框模式
  final bool border;

  /// 文本色
  final Color textColor;

  /// 是否显示阴影
  final bool showShadow;

  /// 是否为圆角模式
  final bool round;

  /// 自定义圆角
  final BorderRadius radius;

  /// 是否禁用按钮
  final bool disabled;

  /// 是否通栏按钮
  final bool long;

  /// 点击回调
  final Function onPressed;

  AppBasedButton({
    Key key,
    this.text,
    this.child,
    this.size: AppBasedButtonSize.base,
    this.color: AppTheme.secondColor,
    this.textColor: Colors.white,
    this.border: false,
    this.showShadow: true,
    this.round: true,
    this.long: true,
    this.disabled: false,
    this.radius,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled == true ? null : onPressed,
      borderRadius: BorderRadius.circular(sizeValue),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: long == true ? button : IntrinsicWidth(child: button),
    );
  }

  /// 按钮外观
  Widget get button {
    return Container(
      height: sizeValue,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: sizeValue / 2),
      decoration: BoxDecoration(
        color: border == true ? Colors.transparent : color,
        borderRadius: radiusValue,
        border: Border.all(
          color: color,
          width: border == true ? 0.75 : 0,
        ),
        boxShadow: shadowSet,
      ),
      child: inner,
    );
  }

  /// 获取按钮内容
  Widget get inner {
    if (child != null) return child;
    return Text(
      text ?? 'Button',
      style: textStyleValue,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  /// 阴影
  List<BoxShadow> get shadowSet {
    if (showShadow == false || border == true) return null;

    return [
      BoxShadow(
        color: color.withOpacity(0.2),
        offset: Offset(0, isDisabled ? 0 : shadowBlurRadius / 2),
        blurRadius: shadowBlurRadius,
      ),
    ];
  }

  /// 按钮是否已禁用
  bool get isDisabled {
    if (onPressed == null || disabled == true) return true;
    return false;
  }

  /// 获取按钮的尺寸
  double get sizeValue {
    if (size == null) return 44.0;
    return {
      AppBasedButtonSize.mini: 24.0,
      AppBasedButtonSize.small: 32.0,
      AppBasedButtonSize.base: 40.0,
      AppBasedButtonSize.large: 54.0,
      AppBasedButtonSize.big: 80.0,
    }[size];
  }

  /// 文本主题
  TextStyle get textStyleValue {
    return TextStyle(
      height: 1.3,
      color: border ? color : textColor,
      fontSize: max(10, sizeValue * 0.37),
      fontWeight: isMiniSize ? FontWeight.normal : FontWeight.w600,
    );
  }

  /// 阴影模糊值
  double get shadowBlurRadius {
    if (size == null) return 8.0;
    return {
      AppBasedButtonSize.mini: 4.0,
      AppBasedButtonSize.small: 6.0,
      AppBasedButtonSize.base: 8.0,
      AppBasedButtonSize.large: 10.0,
      AppBasedButtonSize.big: 12.0,
    }[size];
  }

  /// 是否为小尺寸按钮，小尺寸按钮，字体不加粗
  bool get isMiniSize {
    return size == AppBasedButtonSize.mini;
  }

  /// 获取按钮的圆角值
  BorderRadius get radiusValue {
    if (radius != null) return radius;

    /// 胶囊
    if (round == true) return BorderRadius.circular(sizeValue);
    return BorderRadius.zero;
  }
}
