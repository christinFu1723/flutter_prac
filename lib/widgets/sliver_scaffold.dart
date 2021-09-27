import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/sliver_app_bar.dart';

class AppSliverScaffold extends StatefulWidget {
  /// 页面标题
  final String title;

  /// 使 title 展示为指定组件
  final Widget titleWidget;

  /// 标题前置
  final Widget leading;

  /// 标题间隙
  final double titleSpacing;

  /// 底部展示
  final PreferredSizeWidget bottom;

  /// 标题操作按钮
  final List<Widget> actions;

  /// 页面主体内容
  final Widget body;

  /// 抽屉
  final Widget drawer;
  final Widget endDrawer;

  /// 底部栏
  final Widget bottomNavigationBar;

  /// 内容是否可滚动
  final bool isScrollable;

  final ScrollPhysics physics;

  /// 自定义 Scaffold 组件
  const AppSliverScaffold({
    Key key,
    this.title,
    this.titleWidget,
    this.titleSpacing: 0,
    this.bottom,
    this.leading,
    this.actions,
    this.body,
    this.drawer,
    this.endDrawer,
    this.isScrollable: true,
    this.physics,
    this.bottomNavigationBar,
  });

  @override
  _AppSliverScaffoldState createState() => _AppSliverScaffoldState();
}

class _AppSliverScaffoldState extends State<AppSliverScaffold> {
  // 滚动代理
  ScrollController _scrollController;

  // 当前滚动偏移
  double scrollOffset;

  @override
  void initState() {
    super.initState();

    scrollOffset = 0;

    _scrollController = ScrollController()
      ..addListener(() {
        scrollOffset = _scrollController.offset;
        setState(() {});
      });
  }

  @override
  Scaffold build(BuildContext context) {
    /// 构建 Silver 组件
    List<Widget> _silverBuilder(BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        AppSliverAppBar(
          title: widget.title,
          titleWidget: widget.titleWidget,
          titleSpacing: widget.titleSpacing,
          leading: widget.leading,
          actions: widget.actions,
          bottom: widget.bottom,
          offset: scrollOffset,
          expandedHeight: _expandedHeight(),
        ),
      ];
    }

    return Scaffold(
      key: widget.key,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: _silverBuilder,
        physics: widget.physics ?? BouncingScrollPhysics(),
        body: widget.body ?? Container(),
      ),
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  /// 展开高度
  double _expandedHeight() {
    double _ui = 0;

    /// 状态栏 + 导航栏高度
    _ui += kToolbarHeight;

    /// 存在标题设置
    if (widget.title != null) {
      _ui += 64.0;
    }

    if (widget.bottom != null) {
      _ui += 48.0;
    }

    return _ui;
  }
}
