import 'package:flutter/material.dart';
import 'package:demo7_pro/model/client_config_model.dart';

class AppStoreModel extends ChangeNotifier {
  /// 应用配置信息

  ClientConfigModel clientConfig;

  void setClientConfig(ClientConfigModel config) {
    clientConfig = config;
    notifyListeners();
  }


}