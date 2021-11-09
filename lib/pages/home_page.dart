import 'package:demo7_pro/model/home_model.dart';
import 'package:demo7_pro/model/grid_nav_model.dart';
import 'package:demo7_pro/model/common_model.dart';
import 'package:demo7_pro/model/sales_box_model.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/dao/home_dao.dart';
import 'dart:convert';
import 'package:demo7_pro/widgets/grid_nav.dart';
import 'package:demo7_pro/widgets/sub_nav.dart';
import 'package:demo7_pro/widgets/local_nav.dart';
import 'package:demo7_pro/widgets/sales_box.dart';
import 'package:demo7_pro/widgets/loading_container.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:demo7_pro/widgets/search_bar.dart';
import 'package:demo7_pro/route/pages/webview/index.dart'
    show WebviewPageRoutes;

import 'package:demo7_pro/route/route_util.dart' show navTo;
import 'package:demo7_pro/route/pages/search_page/index.dart'
    show SearchPageRoutes;
import 'package:demo7_pro/route/pages/speak_page//index.dart'
    show SpeakPageRoutes;
import 'package:demo7_pro/route/pages/submit_page/index.dart'
    show SubmitPageRoutes;

import 'package:demo7_pro/dao/get_list_ccm_request_test/get_list.dart'
    show GetListCCMRequestTest;
import 'package:logger/logger.dart';
import 'package:demo7_pro/services/jpush.dart' show JPushService;
import 'package:jpush_flutter/jpush_flutter.dart' show LocalNotification;
import 'package:demo7_pro/utils/data_line/mult_data_line.dart'
    show MultDataLine;

const AppBar_Hide_Distance = 100;
const SEARCH_BAR_DEFAULT_TEXT = '首页默认值';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, MultDataLine {
  String resultString = '';
  HomeModel model;
  GridNavModel gridNav;
  List<CommonModel> localList;
  List<CommonModel> subNavList;
  List<CommonModel> bannerList;
  SalesBoxModel salesBox;
  bool _loading = true;

  String opacityKey = 'home_page_opacity';

  ScrollController _scrollController = ScrollController();

  Future loadData() async {
    print('刷新');
    try {
      var _model = await HomeDao.fetch();
      var _test = await GetListCCMRequestTest.fetch();
      var homeModelInstance = _model['HomeModel'];
      if (!mounted) return;
      setState(() {
        model = _model['HomeModel'];
        gridNav = model.gridNav;
        localList = model.localNavList;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        bannerList = model.bannerList ?? [];
        resultString = json.encode(homeModelInstance.config);
        _loading = false;
      });
      getLine(opacityKey).setData(0); // 初始化组件，否则最开始不渲染。
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState

    loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    Logger().i('我是首页初始化');
    var fireDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch + 1000);
    JPushService.sendLocal(LocalNotification(
      id: 234,
      title: '我是推送测试标题wwwwwwwww',
      buildId: 1,
      content: '看到了说明已经成功了hahahaha',
      fireTime: fireDate,
      subtitle: '一个测试qqqqqqqq',
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('查看是否不停在渲染');

    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        cover: true,
        child: Stack(children: [
          MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Stack(
                children: [
                  RefreshIndicator(
                      onRefresh: loadData,
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification &&
                              scrollNotification.depth == 0) {
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                          return false; // 必须为false
                        },
                        child: _listView,
                      )),
                  Positioned(
                      bottom: 10,
                      right: 5,
                      child: FloatingActionButton(
                        onPressed: () {
                          _jumpToSubmitPage();
                        },
                        child: Icon(Icons.add),
                      ))
                ],
              )),
          _appBar()
        ]),
      ),
    );
  }

  void _onScroll(val) {
    // print(val);
    double alpha = val / AppBar_Hide_Distance;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }

    getLine(opacityKey).setData(alpha); // 调用mult_data_line的buildStream
  }

  Widget _appBar() {
    return getLine(opacityKey).addObserver((context, data) => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0x66000000), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                height: 80,
                decoration: BoxDecoration(
                    color: Color.fromARGB(
                        ((data ?? 0 )* 255).toInt(), 255, 255, 255)),
                child: SearchBar(
                  searchBarType: (data ?? 0) > 0.2
                      ? SearchBarType.homeLight
                      : SearchBarType.home,
                  inputBoxClick: _jumpToSearch,
                  speakClick: _jumpToSpeak,
                  defaultText: SEARCH_BAR_DEFAULT_TEXT,
                  leftButtonClick: () {},
                  autofocus: false,
                  focusNode: null,
                ),
              ),
            ),
            Container(
              height: (data ?? 0) > 0.2 ? 0.5 : 0,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 0.5)
              ]),
            )
          ],
        ));
  }

  Widget get _banner {
    return bannerList != null && bannerList.length >= 1
        ? Container(
            height: 360,
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                return _wrapGesture(
                  context,
                  Image.network(
                    bannerList[index].icon,
                    fit: BoxFit.cover,
                  ),
                  // ImageNetwork(imageUrl:bannerList[index].icon, fit: BoxFit.cover),

                  bannerList[index].url,
                  bannerList[index].title,
                );
              },
              itemCount: bannerList != null ? bannerList.length : 0,
              autoplay: true,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
          )
        : Container();
  }

  Widget get _listView {
    return ListView(
      controller: _scrollController,
      physics: new AlwaysScrollableScrollPhysics(),
      children: [
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList: localList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: GridNav(gridNavModel: gridNav),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SalesBox(salesBox: salesBox),
        ),
      ],
    );
  }

  _wrapGesture(BuildContext context, Widget widget, String url, String title) {
    return GestureDetector(
      onTap: () {
        navTo(context, "${WebviewPageRoutes.webview}",
            clearStack: false,
            arguments: {
              "url": url,
              "title": title,
            });
      },
      child: widget,
    );
  }

  _jumpToSubmitPage() {
    navTo(context, SubmitPageRoutes.submit, clearStack: false);
  }

  _jumpToSearch() {
    navTo(context, "${SearchPageRoutes.search}?hideLeft=${false}",
        clearStack: false,
        arguments: {
          "hint": SEARCH_BAR_DEFAULT_TEXT,
        });
  }

  _jumpToSpeak() {
    navTo(context, SpeakPageRoutes.speak, clearStack: false);
  }
}
