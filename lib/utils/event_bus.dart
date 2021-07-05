import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  EventBus eventBus = new EventBus();

  EventBusUtil._();

  static EventBusUtil instance = new EventBusUtil._();
}
