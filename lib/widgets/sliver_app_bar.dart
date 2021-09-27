import 'dart:math';

import 'package:flutter/material.dart';

import 'package:demo7_pro/config/theme.dart';

class AppSliverAppBar extends StatelessWidget {
  /// 标题文本
  final String title;

  /// 标题栏组件
  final Widget titleWidget;

  /// 标题栏左右边距
  final double titleSpacing;

  /// 前置组件
  final Widget leading;

  /// 后置组件
  final List<Widget> actions;

  /// 底部展示
  final PreferredSizeWidget bottom;

  /// 父级滚动容器的滚动偏移
  final double offset;

  /// 指定展开后的高度
  final double expandedHeight;

  AppSliverAppBar({
    Key key,
    this.title,
    this.titleWidget,
    this.titleSpacing: 0,
    this.offset: 0,
    this.leading,
    this.actions,
    this.bottom,
    this.expandedHeight: 114,
  });

  /// 头部是否折叠
  bool get expanded => offset >= 114 / 4;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: expanded ? Colors.white : AppTheme.backgroundColor,
      title: _title(context),
      titleSpacing: titleSpacing,
      leading: leading,
      actions: actions,
      centerTitle: true,
      elevation: expanded ? 16 : 0,
      shadowColor: Colors.black12.withOpacity(0.2),
      pinned: true,
      stretch: true, // 允许内容伸展
      bottom: bottom,
      expandedHeight: expandedHeight,
      flexibleSpace: _flexibleSpaceTitle(context),
    );
  }

  /// 标题组件
  Widget _title(BuildContext context) {
    /// 指定了标题栏组件时，直接返回标题栏组件
    if (titleWidget != null) return titleWidget;

    if (title != null) {
      return AnimatedContainer(
        child: AnimatedOpacity(
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppTheme.textColor,
              fontSize: AppTheme.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          opacity: expanded ? 1 : 0,
          duration: Duration(milliseconds: expanded ? 230 : 180),
        ),
        duration: Duration(milliseconds: expanded ? 240 : 180),
        curve: expanded ? Curves.easeOut : Curves.easeIn,
        transform: Matrix4.translationValues(0, expanded ? 0 : 10, 0),
      );
    }

    return null;
  }

  Widget _flexibleSpaceTitle(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight,
        left: AppTheme.gutter * 1.5,
        right: AppTheme.gutter * 1.5,
      ),
      child: Opacity(
        opacity: max(0, min(1, 1 - (offset / 48 * 2))),
        child: Container(
          child: Text(
            title ?? '',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppTheme.textColor,
              fontSize: AppTheme.fontSizeName * 1.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      transform: Matrix4.translationValues(0, 0, 0),
    );
  }
}
