class SearchModel {
  List<SearchModelItem> data;
  String keyword;
  SearchModel({this.data,this.keyword});

  SearchModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    this.data =dataList.map((item)=>SearchModelItem.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.data!=null){
      data['data']=this.data.map((item)=>item.toJson()).toList();
    }
    return data;
  }
}

class SearchModelItem {
  String word;
  String type;
  String districtname;
  String url;

  SearchModelItem({this.word, this.type, this.districtname, this.url});

  SearchModelItem.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    type = json['type'];
    districtname = json['districtname'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['type'] = this.type;
    data['districtname'] = this.districtname;
    data['url'] = this.url;
    return data;
  }
}