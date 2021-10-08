import 'package:flutter/material.dart';

import 'package:demo7_pro/model/travel_tab_model.dart';

import 'package:demo7_pro/dao/travel_tab_dao.dart';
import 'package:demo7_pro/pages/travel_tab_page.dart';
import 'package:demo7_pro/route/route_util.dart' show navTo;
import 'package:demo7_pro/route/pages/html_editor_page/html_editor.dart'
    show HtmlEditorPageRoutes;

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _controller;
  List<TravelTabs> tabsList = [];
  TravelTabModel travelTabModel;
  int nowSltTab = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 0, vsync: this);
    _controller.addListener(() {
      setState(() {
        nowSltTab = _controller.index;
      });
    });
    _loadTabs();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _loadTabs() async {
    try {
      var res = await TravelTabDao.fetch();
      TravelTabModel model = res['TravelTabModel'];
      // _controller.dispose();
      _controller = TabController(length: model.tabs.length, vsync: this);
      setState(() {
        tabsList = model.tabs;
        travelTabModel = model;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _floatBtn() {
    return FloatingActionButton(
      onPressed: () {
        navTo(context, HtmlEditorPageRoutes.htmlEditorPage, clearStack: false);
      },
      child: Icon(Icons.edit),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 30),
              child: TabBar(
                controller: _controller,
                isScrollable: true,
                labelColor: Colors.black,
                labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
                    insets: EdgeInsets.only(bottom: 10)),
                tabs: this.tabsList.map((TravelTabs tab) {
                  return Tab(
                    text: tab.labelName,
                  );
                }).toList(),
              ),
            ),
            Flexible(
                child: TabBarView(
              controller: _controller,
              children: this.tabsList.asMap().entries.map((mapItem) {
                return TravelTabPage(
                    travelUrl: travelTabModel.url,
                    groupChannelCode: mapItem.value.groupChannelCode,
                    tabsIndex: mapItem.key,
                    nowSltTab: nowSltTab);
              }).toList(),
            ))
          ],
        ),
        Positioned(
          child: _floatBtn(),
          bottom: 30,
          right: 30,
        )
      ],
    ));
  }
}
