import 'package:demo7_pro/app.dart';
import 'package:demo7_pro/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart' show AppTheme;
import 'package:logger/logger.dart' show Logger;
import 'package:demo7_pro/widgets/common/input.dart' show InputForm;
import 'package:demo7_pro/widgets/common/input_plate.dart' show InputPlate;

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<Map<String, String>> leftColumns = [
    {'label': '测试1', 'value': '1'},
    {'label': '测试2', 'value': '2'},
    {'label': '测试3下载就很照相机血战湘江很自信证监会向证监会向证监会就好', 'value': '3'},
    {'label': '测试4', 'value': '4'},
    {'label': '测试5', 'value': '5'},
    {'label': '测试6', 'value': '6'},
    {'label': '测试7', 'value': '7'},
    {'label': '测试8', 'value': '8'},
    {'label': '测试9', 'value': '9'},
    {'label': '测试10', 'value': '10'},
    {'label': '测试11', 'value': '11'},
    {'label': '测试12', 'value': '12'},
  ];
  List<Map<String, String>> rightColumns = [
    {
      'label': '子选项1zz',
      'relateId': '1',
      'value':
          '1djhsdhjsdhdsjhsdjhsdjhsd是多级合适的就是但广金黄色的季后赛的贵金属的贵金属的季后赛的圣诞节和圣诞节合适的机会收到金黄色的就'
    },
    {'label': '子选项2', 'relateId': '2', 'value': '2'},
    {'label': '子选项3', 'relateId': '3', 'value': '3'},
    {'label': '子选项4', 'relateId': '4', 'value': '4'},
    {'label': '子选项5', 'relateId': '5', 'value': '5'},
    {'label': '子选项6', 'relateId': '6', 'value': '6'},
    {'label': '子选项7', 'relateId': '7', 'value': '7'},
    {'label': '子选项8', 'relateId': '8', 'value': '8'},
    {'label': '子选项9', 'relateId': '9', 'value': '9'},
    {'label': '子选项11', 'relateId': '11', 'value': '11'},
    {'label': '子选项12', 'relateId': '12', 'value': '12'},
    {'label': '子选项13', 'relateId': '1', 'value': '13'},
    {'label': '子选项14', 'relateId': '1', 'value': '14'},
    {'label': '子选项15', 'relateId': '1', 'value': '15'},
    {'label': '子选项16', 'relateId': '1', 'value': '16'},
    {'label': '子选项17', 'relateId': '12', 'value': '17'},
  ];
  String leftCurrentId;
  String rightCurrentId;
  String carNumb;
  TextEditingController searchBarController;

  @override
  void initState() {
    leftCurrentId = leftColumns[0]['value'];
    searchBarController = TextEditingController();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundDefaultColor,
          shadowColor: Colors.transparent,
          leading: backPageButton,
          title: searchBar,
          titleSpacing: 0,
          actions: [searchBtn, iconButton],
        ),
        resizeToAvoidBottomInset: false,
        body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  _scrollTabsChoose(),
                  rightCurrentId != null
                      ? Text('您当前选择的选项为：$rightCurrentId')
                      : Container(),
                  _carNumbInput,
                ],
              ),
            ))));
  }

  Widget get searchBar {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      height: 30,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          InputForm(
            hintStr: '输入搜索',
            textAlign: TextAlign.left,
            controller: searchBarController,
            validatorFn: (val) {},
            onChange: (val) {
              // Logger().i('输入框返回值：$val');
            },
          ),
          Positioned(
              top: 5,
              right: 5,
              child: Icon(Icons.search, color: AppTheme.secondColor, size: 25))
        ],
      ),
    );
  }

  Widget get searchBtn {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: 10),
      child: InkWell(
          child: Text(
            '搜索',
            style: TextStyle(
              color: AppTheme.secondColor,
            ),
          ),
          onTap: () {
            Logger().i('搜索');
          }),
    );
  }

  Widget get backPageButton {
    return GestureDetector(
      child: Icon(
        Icons.arrow_back_ios,
        color: AppTheme.secondColor,
      ),
      onTap: () {
        AppUtil.pop(context);
      },
    );
  }

  Widget get iconButton {
    return Container(
      child: Icon(
        Icons.star,
        color: AppTheme.secondColor,
      ),
    );
  }

  Widget _scrollTabsChoose() {
    return Card(
      child: Container(
        height: 300,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: _leftScrollItem,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: _rightScrollItem,
            ))
          ],
        ),
      ),
    );
  }

  Widget get _rightScrollItem {
    if (this.leftCurrentId != null &&
        this.leftCurrentId != '' &&
        this.rightColumns != null &&
        this.rightColumns.length > 0) {
      List<Map<String, String>> rightColumns = [];
      for (var item in this.rightColumns) {
        if (item['relateId'] == this.leftCurrentId) {
          rightColumns.add(item);
        }
      }
      return Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: rightColumns
                .map((e) => GestureDetector(
                      child: Card(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Icon(
                                    Icons.stream,
                                    color: AppTheme.secondColor,
                                    size: AppTheme.fontSizeSecond,
                                  ),
                                ),
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: 80, maxWidth: 100),
                                    child: Container(
                                      child: Text(
                                        '${e['label']}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: AppTheme.fontSizeSecond,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    children: [
                                      Text(
                                        '${e['value']}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: AppTheme.fontSizeSecond,
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          )),
                      onTap: () {
                        setState(() {
                          this.rightCurrentId = e['value'];
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      );
    }
    return Container();
  }

  Widget get _leftScrollItem {
    if (this.leftColumns == null || this.leftColumns.length <= 0)
      return Container();
    return Column(
      children: this
          .leftColumns
          .map((e) => GestureDetector(
                child: Container(
                  width: 80,
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: AppTheme.placeholderColor.withOpacity(0.1),
                            width: 1)),
                    color: leftCurrentId != e['value']
                        ? AppTheme.placeholderColor.withOpacity(0.3)
                        : Colors.transparent,
                  ),
                  child: Text(
                    '${e['label']}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: AppTheme.fontSizeSmall),
                  ),
                ),
                onTap: () {
                  setState(() {
                    this.leftCurrentId = e['value'];
                  });
                },
              ))
          .toList(),
    );
  }

  Widget get _carNumbInput {
    return Card(
        child: Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('车牌号'),
          InkWell(
            child: Text(
              carNumb ?? '点击输入车牌号',
              style: TextStyle(
                  color: carNumb != null && carNumb != ''
                      ? AppTheme.titleColor
                      : AppTheme.placeholderColor),
            ),
            onTap: () async {
              String value = await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (BuildContext context) => InputPlate(
                  title: '请填写车牌号',
                  text: carNumb ?? '',
                ),
              );
              if(value!=null){
                setState(() {
                  carNumb=value;
                });
              }

            },
          )
        ],
      ),
    ));
  }
}
