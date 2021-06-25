
import 'package:demo7_pro/model/common_model.dart';

// class SalesBoxModel{
//   final String icon;
//   final String moreUrl;
//   final CommonModel bigCard1;
//   final CommonModel bigCard2;
//   final CommonModel smallCard1;
//   final CommonModel smallCard2;
//   final CommonModel smallCard3;
//   final CommonModel smallCard4;
//
//
//
//   // final List<>
//   SalesBoxModel({this.bigCard1,this.icon,this.moreUrl,this.bigCard2,this.smallCard1,this.smallCard2,this.smallCard3,this.smallCard4});
//
//   factory SalesBoxModel.fromJson(Map<String,dynamic> json){
//
//     return SalesBoxModel(
//       bigCard1: CommonModel.fromJson(json['bigCard1']),
//       icon: json['icon'],
//       moreUrl: json['moreUrl'],
//       bigCard2: CommonModel.fromJson(json['bigCard2']),
//
//       smallCard1: CommonModel.fromJson(json['smallCard1']),
//       smallCard2: CommonModel.fromJson(json['smallCard2']),
//       smallCard3: CommonModel.fromJson(json['smallCard3']),
//       smallCard4: CommonModel.fromJson(json['smallCard4']),
//
//     );
//   }
// }

// class SalesBoxModel {
//   SalesBox salesBox;
//
//   SalesBoxModel({this.salesBox});
//
//   SalesBoxModel.fromJson(Map<String, dynamic> json) {
//     salesBox = json['salesBox'] != null
//         ? new SalesBox.fromJson(json['salesBox'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.salesBox != null) {
//       data['salesBox'] = this.salesBox.toJson();
//     }
//     return data;
//   }
// }

class SalesBoxModel {
  String icon;
  String moreUrl;
  BigCard1 bigCard1;
  BigCard1 bigCard2;
  BigCard1 smallCard1;
  BigCard1 smallCard2;
  BigCard1 smallCard3;
  BigCard1 smallCard4;

  SalesBoxModel(
      {this.icon,
        this.moreUrl,
        this.bigCard1,
        this.bigCard2,
        this.smallCard1,
        this.smallCard2,
        this.smallCard3,
        this.smallCard4});

  SalesBoxModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    moreUrl = json['moreUrl'];
    bigCard1 = json['bigCard1'] != null
        ? new BigCard1.fromJson(json['bigCard1'])
        : null;
    bigCard2 = json['bigCard2'] != null
        ? new BigCard1.fromJson(json['bigCard2'])
        : null;
    smallCard1 = json['smallCard1'] != null
        ? new BigCard1.fromJson(json['smallCard1'])
        : null;
    smallCard2 = json['smallCard2'] != null
        ? new BigCard1.fromJson(json['smallCard2'])
        : null;
    smallCard3 = json['smallCard3'] != null
        ? new BigCard1.fromJson(json['smallCard3'])
        : null;
    smallCard4 = json['smallCard4'] != null
        ? new BigCard1.fromJson(json['smallCard4'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['moreUrl'] = this.moreUrl;
    if (this.bigCard1 != null) {
      data['bigCard1'] = this.bigCard1.toJson();
    }
    if (this.bigCard2 != null) {
      data['bigCard2'] = this.bigCard2.toJson();
    }
    if (this.smallCard1 != null) {
      data['smallCard1'] = this.smallCard1.toJson();
    }
    if (this.smallCard2 != null) {
      data['smallCard2'] = this.smallCard2.toJson();
    }
    if (this.smallCard3 != null) {
      data['smallCard3'] = this.smallCard3.toJson();
    }
    if (this.smallCard4 != null) {
      data['smallCard4'] = this.smallCard4.toJson();
    }
    return data;
  }
}

class BigCard1 {
  String icon;
  String url;
  String title;

  BigCard1({this.icon, this.url, this.title});

  BigCard1.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['url'] = this.url;
    data['title'] = this.title;
    return data;
  }
}