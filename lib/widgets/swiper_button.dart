import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart';
import 'dart:math';
import 'package:logger/logger.dart';

class SwiperButton extends StatefulWidget {
  /// 滑块高度
  final double size;

  /// 主题配色
  final Color color;

  /// 占位提示
  final String placeholder;

  /// 拖动开始执行的回调
  final VoidCallback onSwiperStart;

  /// 滑动完成时执行验证
  ///
  /// 验证回调需要返回一个 OnValidate 值；
  ///
  /// 验证通过时继续调用回调;
  ///
  /// 验证失败时，终止执行，且回退动画
  final Future<bool> Function() onSwiperValidate;

  SwiperButton({
    Key key,
    this.size: 44,
    this.color: AppTheme.primaryColor,
    this.placeholder: '滑动完成',
    this.onSwiperStart,
    this.onSwiperValidate,
  }) : super(key: key);

  @override
  _SwiperButtonState createState() => _SwiperButtonState();
}

class _SwiperButtonState extends State<SwiperButton> {
  /// 开始位置
  double dxStart;

  /// 实时拖动位置
  double dxNow;

  /// 拖动距离
  double dxMoved;

  /// 是否允许继续拖动
  bool canDrag;

  /// 是否推动完成
  bool dragEnded;

  @override
  void initState() {
    super.initState();
    canDrag = false;
    dragEnded = false;
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      child: swiperBtnBody,
      onHorizontalDragStart: (DragStartDetails details) {
        /// 开始拖动时
        canDrag = true;
        dragEnded = false;
        dxMoved = 0;
        dxStart = details.globalPosition.dx;
        setState(() {});
        if (widget.onSwiperStart != null) widget.onSwiperStart.call();
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) async {
        if (canDrag == false) return;

        if (dxMoved >= dxMax) {
          /// 禁用拖动
          canDrag = false;
          dragEnded = true;
          setState(() {});

          /// 执行验证
          if (widget.onSwiperValidate != null) {
            bool _validate = await widget.onSwiperValidate.call();

            if (_validate != true) {
              reset();
              return;
            }
          } else {
            reset();
          }
          return;
        }
        dxNow = details.globalPosition.dx;
        dxMoved = max(0, dxNow - dxStart);
        setState(() {});
      },

      /// 拖动结束
      onHorizontalDragEnd: (DragEndDetails details) {
        if (dragEnded == true) return;

        dxMoved = 0;
        canDrag = false;
        setState(() {});
      },
    );
  }

  /// 最大拖动距离
  double get dxMax {
    final RenderBox box = context.findRenderObject();
    if (box == null) return 0;
    double size = box.size.width - ((2 * 2) + (1 * 2));
    return size - widget.size ?? 44;
  }

  /// 重置
  void reset() {
    canDrag = false;
    dragEnded = true;
    dxNow = 0;
    dxMoved = 0;

    if (!mounted) return;
    setState(() {});
  }

  int get buttonTipsAlpha {
    int whole = dxMoved?.toInt() ?? 0;
    whole = whole >= 0
        ? whole > 255
            ? 255
            : whole
        : 0;
    return whole;
  }

  Widget get swiperBtnBody {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: AppTheme.borderColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(widget.size),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset.zero,
              blurRadius: AppTheme.gutter * 2,
            ),
            BoxShadow(
              color: Colors.white,
              spreadRadius: 4,
            ),
          ]),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: AnimatedContainer(
              duration: canDrag == true
                  ? Duration.zero
                  : Duration(milliseconds: 1000),
              curve: Curves.bounceOut,
              // 反弹动画
              width: min(dxMax, dxMoved ?? 0) + widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.size),
              ),
            ),
          ),
          Container(
            height: widget.size,
            alignment: Alignment.center,
            child: Text(
              widget.placeholder ?? '', // placeholder默认样式
              style: TextStyle(
                  color: AppTheme.lightTextColor.withOpacity(0.8),
                  fontSize: AppTheme.fontSizeBase - 2),
            ),
          ),
          Positioned(
            child: Container(
              height: widget.size,
              alignment: Alignment.center,
              child: Text(
                widget.placeholder ?? '', //placeholder动画样式

                style: TextStyle(
                  color: Colors.white.withAlpha(buttonTipsAlpha),
                  fontSize: AppTheme.fontSizeBase - 2,
                ),
              ),
            ),
          ),
          Positioned(
              left: 0,
              top: 0,
              child: AnimatedContainer(
                height: widget.size,
                width: widget.size,
                duration: canDrag == true
                    ? Duration.zero
                    : Duration(milliseconds: 1000),
                curve: Curves.bounceOut,
                // 反弹动画
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: min(dxMax, dxMoved ?? 0),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, AppTheme.gutter),
                          blurRadius: AppTheme.gutter * 2)
                    ]),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: widget.color,
                ),
              ))
        ],
      ),
    );
  }
}
