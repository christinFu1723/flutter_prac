import 'package:demo7_pro/model/common_model.dart';

import 'package:flutter/material.dart';
import 'package:demo7_pro/model/grid_nav_model.dart';
import 'package:demo7_pro/route/pages/webview/index.dart'
    show WebviewPageRoutes;
import 'package:demo7_pro/route/route_util.dart' show navTo;

class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    return items;
  }

  _parse16StrIntoColor([String colorStr = 'ffffff']) {
    return Color(int.parse('0xff$colorStr'));
  }

  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2, true));
    items
        .add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4, false));
    List<Widget> expandItems = [];
    items.forEach((element) {
      expandItems.add(Expanded(
        child: element,
        flex: 1,
      ));
    });
    return Container(
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        _parse16StrIntoColor(gridNavItem.startColor ?? 'cccccc'),
        _parse16StrIntoColor(gridNavItem.endColor ?? 'cccccc')
      ])),
      child: Row(
        children: expandItems,
      ),
    );
  }

  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Image.network(
              model.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
                margin: EdgeInsets.only(top: 11),
                child: Text(
                  model.title,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ))
          ],
        ),
        model);
  }

  _doubleItem(BuildContext context, CommonModel topItem,
      CommonModel bottomModel, bool isCenterItem) {
    return Column(
      children: [
        Expanded(
          // 垂直方向上展开占满
          child: _item(context, topItem, isCenterItem, true),
        ),
        Expanded(
          // 垂直方向上展开占满
          child: _item(context, bottomModel, isCenterItem, false),
        )
      ],
    );
  }

  _item(
      BuildContext context, CommonModel item, bool isCenterItem, bool isFirst) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      // 水平方向上宽度占满
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: borderSide,
                bottom: isFirst ? borderSide : BorderSide.none)),
        child: _wrapGesture(context, _itemTitle(item.title), item),
      ),
    );
  }

  _itemTitle(String title) {
    return Center(
      child: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.white)),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        navTo(context, "${WebviewPageRoutes.webview}", arguments: {
          "url": model.url,
          "statusBar": model.statusBarColor,
          "hideAppBar": model.hideAppBar,
          "title": model.title,
        });
      },
      child: widget,
    );
  }
}

// class GridNav extends StatefulWidget{
//   final GridNavModel gridNavModel;
//   const GridNav({Key key,@required this.gridNavModel}):super(key:key);
//
//   @override
//   State<StatefulWidget> createState(){
//     return _GridNavState();
//   }
// }
//
// class _GridNavState extends State<GridNav>{
//   @override
//   Widget build(BuildContext context){
//     return Text('GridNav');
//   }
// }
