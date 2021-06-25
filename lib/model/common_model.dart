

class CommonModel{
  final String icon;
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;


  // final List<>
  CommonModel({this.icon,this.title,this.url,this.statusBarColor,this.hideAppBar,});

  factory CommonModel.fromJson(Map<String,dynamic> json){
    return CommonModel(
      icon: json['icon'],
      title: json['title'],
      url: json['url'],
      statusBarColor: json['statusBarColor'],
      hideAppBar: json['hideAppBar'],
    );
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> map = new Map<String,dynamic>();
    map['icon']=this.icon;
    map['title']=this.title;
    map['url']=this.url;
    map['statusBarColor']=this.statusBarColor;
    map['hideAppBar']=this.hideAppBar;
    return map;
  }
}