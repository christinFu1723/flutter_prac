import 'package:flutter/material.dart';

import 'package:vibrate/vibrate.dart';

import 'package:demo7_pro/config/theme.dart';
import 'package:demo7_pro/utils/app.dart';
import 'package:demo7_pro/utils/string.dart';
import 'package:demo7_pro/route/route_util.dart' show pop;

/// 车牌输入
///
/// String value = await showModalBottomSheet(
///   context: context,
///   backgroundColor: Colors.transparent,
///   isScrollControlled: true,
///   builder: (BuildContext context) => InputPlate(
///     title: '请填写车牌号',
///     text: '京A88B88',
///   ),
/// );
class InputPlate extends StatefulWidget {
  final String text;

  final String title;

  InputPlate({
    Key key,
    this.text,
    this.title = '请填写车牌号',
  }) : super(key: key);

  @override
  _InputPlateState createState() => _InputPlateState();
}

class _InputPlateState extends State<InputPlate> {
  /// 已输入值
  List<String> input;

  /// 当前聚焦的索引下标
  int pointerIndex;

  @override
  void initState() {
    /// 初始化输入字符
    input = List<String>.filled(8, '', growable: true);

    if (!StringUtil.isEmpty(widget.text)) {
      List<String> _preset = widget.text.split('');
      for (int i = 0; i < _preset.length; i++) {
        input[i] = _preset[i];
      }
    }

    if (!StringUtil.isEmpty(widget.text)) {
      pointerIndex = widget.text.length - 1;
    } else {
      pointerIndex = 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.gutter),
          ),
        ),
        child: SafeArea(child: layout),
      ),
    );
  }

  /// 布局
  Widget get layout {
    return Column(
      children: [
        title,
        refer,
        pointerIndex == 0 ? keyboardPrefix : keyboardLetters,
      ],
    );
  }

  Widget get title {
    return Stack(
      children: [
        Container(
          height: 80,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.gutter,
            vertical: AppTheme.gutter,
          ),
          child: Text(
            widget.title ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTheme.fontSizeBase,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          right: AppTheme.gutter / 2,
          top: AppTheme.gutter / 2,
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: AppTheme.lightTextColor,
            ),
            onPressed: () {
              pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget get refer {
    return Container(
      padding: EdgeInsets.only(
        left: AppTheme.gutter,
        right: AppTheme.gutter,
        bottom: AppTheme.gutter,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item(getIndexStr(0), index: 0),
          item(getIndexStr(1), index: 1),
          item(null, split: true),
          item(getIndexStr(2), index: 2),
          item(getIndexStr(3), index: 3),
          item(getIndexStr(4), index: 4),
          item(getIndexStr(5), index: 5),
          item(getIndexStr(6), index: 6),
          item(getIndexStr(7), index: 7, newEnergy: true),
        ],
      ),
    );
  }

  String getIndexStr(int index) {
    if (input == null || input.isEmpty) return '';
    if (input.length <= index) return '';
    return input[index] ?? '';
  }

  Widget item(
    String text, {
    int index,
    bool split,
    bool newEnergy = false,
  }) {
    double size = MediaQuery.of(context).size.width - (AppTheme.gutter * 2);
    size = size - (AppTheme.gutter / 2) * 8;
    size = size / 9;

    if (split == true) {
      return Container(
        width: size / 8,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }

    /// 新能源占位
    Widget placeholder = newEnergy
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: AppTheme.sitSuccessColor,
                size: 12,
              ),
              SizedBox(height: 2),
              Text(
                '新能源',
                style: TextStyle(
                  color: AppTheme.sitSuccessColor,
                  fontSize: 8,
                ),
              )
            ],
          )
        : Container();

    Widget content = Container(
      width: size,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: (index == pointerIndex
                        ? AppTheme.primaryColor
                        : AppTheme.borderColor)
                    .withOpacity(0.2),
                offset: Offset.zero,
                blurRadius: 0,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: index == pointerIndex
                  ? AppTheme.primaryColor
                  : AppTheme.borderColor,
              width: 0.5,
            ),
          ),
          child: StringUtil.isEmpty(text)
              ? placeholder
              : Text(
                  text ?? '',
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeBase,
                  ),
                ),
        ),
      ),
    );

    return InkWell(
      child: content,
      onTap: () {
        pointerIndex = index;
        setState(() {});
      },
    );
  }

  Widget get keyboardPrefix {
    return Container(
      color: AppTheme.borderColor.withOpacity(0.5),
      padding: EdgeInsets.all(AppTheme.gutter),
      width: double.infinity,
      child: Wrap(
        spacing: AppTheme.gutter / 2,
        runSpacing: AppTheme.gutter / 2,
        alignment: WrapAlignment.center,
        children: prefixKeys,
      ),
    );
  }

  /// 前缀键盘
  List<Widget> get prefixKeys {
    // 计算单个元素的尺寸
    double size = MediaQuery.of(context).size.width - (AppTheme.gutter * 2);
    size = size - (AppTheme.gutter / 2) * 8;
    size = size / 9;

    List<String> prefix = '京津沪渝蒙新藏宁桂贵云黑吉辽晋冀青鲁豫苏皖浙闽赣湘鄂粤琼甘陕川港澳'.split('');

    /// 创建数据
    List<Widget> _keys = List<Widget>.generate(prefix.length, (index) {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: () async {
          bool canVibrate = await Vibrate.canVibrate;
          if (canVibrate == true) {
            Vibrate.feedback(FeedbackType.selection);
          }
          input[0] = prefix[index];
          pointerIndex = 1;
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            prefix[index],
            style: TextStyle(fontSize: AppTheme.fontSizeName - 2),
          ),
          height: size * 1.2,
          width: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    });

    /// 清除按钮
    Widget backspace = InkWell(
      onTap: () {
        if (input[0] != null) {
          input[0] = null;
        } else {
          pointerIndex = 0;
        }
        setState(() {});
      },
      child: Container(
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace,
          size: 16,
          color: AppTheme.sitDangerColor,
        ),
        height: size * 1.2,
        width: size * 1.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    _keys.add(backspace);

    Widget confirm = InkWell(
      splashColor: Colors.transparent,
      onTap: handleSubmit,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '确定',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppTheme.fontSizeBase - 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        height: size * 1.2,
        width: size * 1.6 + (AppTheme.gutter / 2),
        decoration: BoxDecoration(
          color: AppTheme.secondColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    _keys.add(confirm);

    return _keys;
  }

  /// 数字字母键盘
  Widget get keyboardLetters {
    // 计算单个元素的尺寸
    double size = MediaQuery.of(context).size.width - (AppTheme.gutter * 2.1);
    size = size - (4 * 9);
    size = size / 10;

    List<String> presets = '1234567890QWERTYUIOPASDFGHJKLZXCVBNM'.split('');

    List<Widget> _keys = List<Widget>.generate(presets.length, (index) {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: () async {
          bool canVibrate = await Vibrate.canVibrate;
          if (canVibrate == true) {
            Vibrate.feedback(FeedbackType.selection);
          }
          input[pointerIndex] = presets[index];
          if (pointerIndex < 7) {
            pointerIndex += 1;
          }
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            presets[index],
            style: TextStyle(
              fontSize: AppTheme.fontSizeName - 2,
            ),
          ),
          height: size * 1.2,
          width: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    });

    /// 清除按钮
    Widget backspace = InkWell(
      onTap: () {
        if (pointerIndex > 0) {
          if (input[pointerIndex] != null) {
            input[pointerIndex] = null;
          } else {
            pointerIndex -= 1;
          }
          setState(() {});
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace,
          size: 16,
          color: AppTheme.sitDangerColor,
        ),
        height: size * 1.2,
        width: size * 2 + (4 / 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    _keys.add(backspace);

    Widget confirm = InkWell(
      splashColor: Colors.transparent,
      onTap: handleSubmit,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '确定',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppTheme.fontSizeBase - 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        height: size * 1.2,
        width: size * 2 + (4 / 2),
        decoration: BoxDecoration(
          color: AppTheme.secondColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    _keys.add(confirm);

    return Container(
      color: AppTheme.borderColor.withOpacity(0.5),
      padding: EdgeInsets.only(
        left: AppTheme.gutter,
        right: AppTheme.gutter,
        bottom: AppTheme.gutter,
        top: AppTheme.gutter / 2,
      ),
      width: double.infinity,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        alignment: WrapAlignment.center,
        children: _keys,
      ),
    );
  }

  Future<void> handleSubmit() async {
    try {
      String _input =
          input.map((e) => StringUtil.isEmpty(e) ? '' : e).toList().join('');

      /// 允许为空
      if (StringUtil.isEmpty(_input)) {
        pop(context, result: '');
        return;
      }

      if (_input.length < 7) throw '输入错误，请检查';

      pop(context, result: _input);
    } catch (e) {
      AppUtil.showToast(e);
    }
  }
}
