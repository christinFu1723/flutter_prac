import 'package:demo7_pro/pages/home_page.dart';
import 'package:demo7_pro/pages/my_page.dart';
import 'package:demo7_pro/pages/search_page.dart';
import 'package:demo7_pro/pages/travel_page.dart';
import 'package:flutter/material.dart';

class TabConfig {
  static List<Widget> tab = [MyHomePage(), SearchPage(), TravelPage(), MyPage()];
  static MaterialColor defaultColor = Colors.grey;
  static MaterialColor activeColor = Colors.blue;
  static int index = 0;
}
