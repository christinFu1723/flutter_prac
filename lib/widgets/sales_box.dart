import 'package:flutter/material.dart';

import 'package:demo7_pro/model/sales_box_model.dart';
import 'package:demo7_pro/route/pages/webview/index.dart'
    show WebviewPageRoutes;
import 'package:demo7_pro/route/route_util.dart' show navTo;

class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBox;

  const SalesBox({Key key, @required this.salesBox}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: _items(context),
    );
  }

  Widget _items(BuildContext context) {
    if (salesBox == null) return null;

    return Column(
      children: [
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xfff2f2f2)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(salesBox.icon, height: 15, fit: BoxFit.fill),
              // ImageNetwork(imageUrl:salesBox.icon,height: 15,fit:BoxFit.fill),
              Container(
                  padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                  margin: EdgeInsets.only(right: 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                          colors: [Color(0xffff4e63), Color(0xffff6cc9)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: _wrapGesture(
                      context,
                      Text(
                        '获取更多福利 >',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      salesBox.moreUrl,
                      '更多活动'))
            ],
          ),
        ),
        _doubleItem(context, salesBox.bigCard1, salesBox.bigCard2, true, false),
        _doubleItem(
            context, salesBox.smallCard1, salesBox.smallCard2, false, false),
        _doubleItem(
            context, salesBox.smallCard3, salesBox.smallCard4, false, true)
      ],
    );
  }

  Widget _doubleItem(BuildContext context, BigCard1 leftCard,
      BigCard1 rightCard, bool big, bool last) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _item(context, leftCard, true, big, last),
        _item(context, rightCard, false, big, last)
      ],
    );
  }

  Widget _item(
      BuildContext context, BigCard1 model, bool left, bool big, bool last) {
    BorderSide borderSide =
        BorderSide(width: 0.8, color: Color(int.parse('0xfff2f2f2')));
    return Expanded(
        child: GestureDetector(
            onTap: () {
              navTo(context, "${WebviewPageRoutes.webview}", arguments: {
                "url": model.url,
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      right: left ? borderSide : BorderSide.none,
                      bottom: last ? BorderSide.none : borderSide)),
              child: Image.network(
                model.icon,
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: big ? 129 : 80,
                fit: BoxFit.fill,
              ),
              // ImageNetwork(imageUrl:model.icon,width: MediaQuery.of(context).size.width /2 -10,height: big?129:80,fit:BoxFit.fill),
              // Padding(padding:
              // EdgeInsets.only(top:3),
              //     child:Text(model.title,style: TextStyle(fontSize: 12),
              //     ))
            )));
  }

  _wrapGesture(BuildContext context, Widget widget, String url, String title) {
    return GestureDetector(
      onTap: () {
        navTo(context, "${WebviewPageRoutes.webview}", arguments: {
          "url": url,
          "title": title,
        });
      },
      child: widget,
    );
  }
}
