import 'package:demo7_pro/model/config_model.dart';
import 'package:demo7_pro/model/common_model.dart';
import 'package:demo7_pro/model/grid_nav_model.dart';
import 'package:demo7_pro/model/sales_box_model.dart';

//https://www.devio.org/io/flutter_app/json/home_page.json
class HomeModel{
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel({this.config,this.bannerList,this.localNavList,this.gridNav,this.salesBox,this.subNavList});
  
  factory HomeModel.fromJson(Map<String,dynamic>json){



    var localNavListJson = json['localNavList'] as List;


    List<CommonModel> localNavList = localNavListJson.map((i)=>CommonModel.fromJson(i)).toList();
    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList = bannerListJson.map((i)=>CommonModel.fromJson(i)).toList();
    var subNavListJson = json['subNavList'] as List;

    List<CommonModel> subNavList = subNavListJson.map((i){

      return CommonModel.fromJson(i);

    }).toList();

    return HomeModel(
      localNavList: localNavList,
        bannerList:bannerList,
        subNavList:subNavList,
        gridNav:GridNavModel.fromJson(json['gridNav']),
        config: ConfigModel.fromJson(json['config']),
        salesBox: SalesBoxModel.fromJson(json['salesBox']),


    );
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic>data =new Map<String,dynamic>();
    // final ConfigModel config;
    // final List<CommonModel> bannerList;
    // final List<CommonModel> localNavList;
    // final List<CommonModel> subNavList;
    // final GridNavModel gridNav;
    // final SalesBoxModel salesBox;
    data['config']=this.config.toJson();
    data['bannerList']=this.bannerList.map((v)=>{v.toJson()});
    data['localNavList']=this.localNavList.map((v)=>{v.toJson()});
    data['subNavList']=this.subNavList.map((v)=>{v.toJson()});
    data['gridNav']=this.gridNav.toJson();
    data['salesBox']=this.salesBox.toJson();
    return data;
  }
}