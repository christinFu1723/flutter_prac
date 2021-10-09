/// 需要重新登录
///
/// HTTP 检测到需要重新登录时，调用该事件，APP 将清除缓存信息，跳转到登录页面
class NeedReLoginEvent {}

class HomeTabChangeEvent {
  final int index;

  HomeTabChangeEvent(this.index);
}
