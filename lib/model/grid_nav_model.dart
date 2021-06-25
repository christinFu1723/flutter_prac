
import 'package:demo7_pro/model/common_model.dart';
class GridNavModel{
  final GridNavItem hotel;
  final GridNavItem flight;
  final GridNavItem travel;



  // final List<>
  GridNavModel({this.hotel,this.flight,this.travel});

  factory GridNavModel.fromJson(Map<String,dynamic> json){
    return json!=null?(
        GridNavModel(
          hotel:  GridNavItem.fromJson(json['hotel']),
          flight:  GridNavItem.fromJson(json['flight']),
          travel:  GridNavItem.fromJson(json['travel']),

        )
    ):(null);
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic>data =new Map<String,dynamic>();
    data['hotel']=this.hotel.toJson();
    data['flight']=this.flight.toJson();
    data['travel']=this.travel.toJson();
    return data;
  }
}
class GridNavItem{
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;


  // final List<>
  GridNavItem({this.mainItem,this.startColor,this.endColor,this.item1,this.item2,this.item3,this.item4,});

  factory GridNavItem.fromJson(Map<String,dynamic> json){
    return GridNavItem(
      mainItem: CommonModel.fromJson(json['mainItem']),
      startColor: json['startColor'],
      endColor: json['endColor'],
      item1: CommonModel.fromJson(json['item1']),
      item2: CommonModel.fromJson(json['item2']),
      item3: CommonModel.fromJson(json['item3']),
      item4: CommonModel.fromJson(json['item4']),
    );
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new  Map<String,dynamic>();
    data['startColor']=this.startColor;
    data['endColor']=this.endColor;
    data['mainItem']=this.mainItem.toJson();
    data['item1']=this.item1.toJson();
    data['item2']=this.item2.toJson();
    data['item3']=this.item3.toJson();
    data['item4']=this.item4.toJson();
    return data;
  }
}