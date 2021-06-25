import 'package:flutter/material.dart';
import 'package:demo7_pro/pages/home_page.dart';
import 'package:demo7_pro/tabbar/tab_nav.dart';
void main() {
  runApp(MaterialApp(
      title: '阿福首页',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    ));
}
