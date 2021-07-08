import 'package:demo7_pro/model/personal_information.dart';
import 'package:flutter/material.dart';
// import 'package:demo7_pro/services/jpush.dart';
import 'package:demo7_pro/enums/user_type.dart';
// import 'package:demo7_pro/models/common/address.dart';

/// 用户状态
///
/// 维护用户的 基本信息、地址信息、企业信息、网点信息
class PersonalStoreModel extends ChangeNotifier {
  /// 用户信息
  PersonalInfomationModel user;

  /// 设置用户信息
  setUser(PersonalInfomationModel personal) async {
    user = personal;
    print('=' * 200);
    print(personal.toJson());
    notifyListeners();
  }

  /// 删除用户信息
  removeUser() {
    user = null;
    notifyListeners();
  }

  /// 用户是否已完成实人认证
  bool get isValidated {
    if (user == null) return false;
    return user?.certificationStatus == 'CERTIFIED';
  }

  ///////////////////////////////////////////////////

  /// 用户身份信息，会员 或 服务商
  String identity;

  setIdentity(String value) {
    identity = value;
    notifyListeners();
  }

  EnumUserType get identityValue {
    if (identity == null) return null;
    return {
      'member': EnumUserType.member,
      'supplier': EnumUserType.supplier,
    }[identity];
  }

  /// 当前是否处于委托商环境下
  bool get isInMemberMode {
    if (identity == null) return false;
    return this.identityValue == EnumUserType.member;
  }

  /// 当前是否处于服务商环境下
  bool get isInSupplierMode {
    if (identity == null) return false;
    return this.identityValue == EnumUserType.supplier;
  }

  removeIdentity() {
    identity = null;
    notifyListeners();
  }

  ///////////////////////////////////////////////////

  /// 地址信息（默认地址）
  // AddressModel address;
  //
  // setAddress(AddressModel value) {
  //   address = value;
  //   notifyListeners();
  // }

  // removeAddress() {
  //   address = null;
  //   notifyListeners();
  // }

  ///////////////////////////////////////////////////

  /// 未读公告数
  int announceRecordsUnreadCount;

  /// 未读提醒数
  int remindRecordsUnreadCount;

  /// 总消息未读数
  int get messageUnreadCount {
    int _aruc = announceRecordsUnreadCount ?? 0;
    int _rruc = remindRecordsUnreadCount ?? 0;
    return _aruc + _rruc;
  }

  /// 设置未读公告数
  void setAnnounceRecordsUnreadCount(int count) {
    announceRecordsUnreadCount = count;
    notifyListeners();
  }

  /// 设置未读提醒数
  void setRemindRecordsUnreadCount(int count) {
    remindRecordsUnreadCount = count;
    notifyListeners();
  }

  /// 清除信息数据
  void resetUnreadCount() {
    announceRecordsUnreadCount = 0;
    remindRecordsUnreadCount = 0;
    // JPushService.setBadge(0);
    notifyListeners();
  }

  ///////////////////////////////////////////////////

  /// 服务商 - 抢单提示
  bool grabbingNotify = true;

  /// 设置未读提醒数
  void setGrabbingNotify(bool status) {
    grabbingNotify = status;
    notifyListeners();
  }

  /// 设置未读提醒数
  void removeGrabbingNotify() {
    grabbingNotify = null;
    notifyListeners();
  }

  ///////////////////////////////////////////////////

}
