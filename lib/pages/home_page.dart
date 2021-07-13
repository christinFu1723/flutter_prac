import 'package:demo7_pro/model/home_model.dart';
import 'package:demo7_pro/model/grid_nav_model.dart';
import 'package:demo7_pro/model/common_model.dart';
import 'package:demo7_pro/model/sales_box_model.dart';

import 'package:demo7_pro/pages/speak_page.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/dao/home_dao.dart';
import 'dart:convert';
import 'package:demo7_pro/widgets/grid_nav.dart';
import 'package:demo7_pro/widgets/sub_nav.dart';
import 'package:demo7_pro/widgets/local_nav.dart';
import 'package:demo7_pro/widgets/sales_box.dart';
import 'package:demo7_pro/widgets/loading_container.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:demo7_pro/widgets/webview.dart';
import 'package:demo7_pro/widgets/search_bar.dart';
import 'package:demo7_pro/pages/search_page.dart';
import 'package:demo7_pro/widgets/imageNetwork.dart';

const AppBar_Hide_Distance = 100;
const SEARCH_BAR_DEFAULT_TEXT='首页默认值';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String resultString='';
  HomeModel model;
  GridNavModel gridNav;
  List<CommonModel> localList;
  List<CommonModel> subNavList;
  List<CommonModel> bannerList;
  SalesBoxModel salesBox;
  bool _loading=true;
  double appBarAlpha = 0;


  ScrollController _scrollController = ScrollController();
  Future loadData() async{
    print('刷新');
    try{
      var _model = await  HomeDao.fetch();
      var homeModelInstance =_model['HomeModel'];

      setState((){
        model=_model['HomeModel'];
        gridNav=model.gridNav;
        localList=model.localNavList;
        subNavList=model.subNavList;
        salesBox = model.salesBox;
        bannerList = model.bannerList??[];
        resultString=json.encode(homeModelInstance.config);
        _loading=false;
      });
    }
    catch(e){
      setState((){
        _loading=false;
      });
    }
    return null;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){

      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
             backgroundColor: Color(0xfff2f2f2),
             body:
             LoadingContainer(
                isLoading: _loading,
                cover: true,
                child: Stack(
                  children:[
                   MediaQuery.removePadding(
                       context: context,
                       removeTop: true,
                       child:RefreshIndicator(
                           onRefresh: loadData,
                           child:NotificationListener(
                             onNotification: (scrollNotification) {
                               if (scrollNotification is ScrollUpdateNotification &&
                                   scrollNotification.depth == 0) {
                                 _onScroll(scrollNotification.metrics.pixels);
                               }
                               return false;// 必须为false
                             },
                             child:_listView,
                           )
                    )
                   ),

                    _appBar
                 ]
               ),
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
    setState(() {
      appBarAlpha = alpha;
    });
  }

  Widget get _appBar {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000),Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child:Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha*255).toInt(), 255, 255, 255)
            ),
            child:SearchBar(
              searchBarType: appBarAlpha>0.2?SearchBarType.homeLight:SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: (){},
            ),
          ) ,
        ),
        Container(
          height: appBarAlpha>0.2?0.5:0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 0.5)]
          ),
        )
      ],
    );


  }
  Widget get _banner{
    return    Container(
      height: 160,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return _wrapGesture(
            context,
            // Image.network(
            //   bannerList[index].icon,
            //   fit: BoxFit.cover,
            // ),
            ImageNetwork(imageUrl:bannerList[index].icon),

            bannerList[index].url,
            bannerList[index].title,
          );
        },
        itemCount: bannerList!=null?bannerList.length:0,
        autoplay: true,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }
  Widget get _listView{
    return ListView(
      controller: _scrollController,
      physics:new AlwaysScrollableScrollPhysics(),
      children: [
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(localNavList:localList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child:GridNav(gridNavModel:gridNav),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SubNav(subNavList:subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: SalesBox(salesBox:salesBox),
        ),
      ],
    );
  }

  _wrapGesture(BuildContext context,Widget widget,String url,String title){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>
                WebView(
                  url: url,

                  title: title,
                )
            ));
      },
      child: widget,
    );
  }
  _jumpToSearch(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context){
              return SearchPage(hideLeft:false,hint:SEARCH_BAR_DEFAULT_TEXT);
            })
    );
  }
  _jumpToSpeak(){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SpeakPage())
    );

  }
}

