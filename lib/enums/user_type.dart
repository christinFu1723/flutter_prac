/// 用户类型
enum EnumUserType {
  /// 游客
  guest,

  /// 会员
  member,

  /// 服务商
  supplier,
}

/// 获取枚举类型
String getEnumUserTypeValue(EnumUserType type) {
  return {
    EnumUserType.guest: 'guset',
    EnumUserType.member: 'member',
    EnumUserType.supplier: 'supplier',
  }[type];
}
