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
import 'package:dio_log/dio_log.dart';
import 'package:get/get.dart';


const AppBar_Hide_Distance = 100;
const SEARCH_BAR_DEFAULT_TEXT = '首页默认值';

class MyPageController extends GetxController {}

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPageController>(
          () => MyPageController(),
    );
  }
}

class MyPageGET extends GetView<MyPageController> with MultDataLine {


  @override
  Widget build(BuildContext context) {
    showDebugBtn(context, btnColor: Colors.blue);

    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: Container(child: Text('我的')));
  }

}
