import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controllers/root_controller.dart';


class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, current) {
        final title = current?.location;
        return Scaffold(

          body: GetRouterOutlet(
            initialRoute: '/tabbar',
            // anchorRoute: '/',
            // filterPages: (afterAnchor) {
            //   return afterAnchor.take(1);
            // },
          ),
        );
      },
    );
  }
}
