class BannerList {
  List<BannerListItem> bannerList;

  BannerList({this.bannerList});

  BannerList.fromJson(Map<String, dynamic> json) {
    if (json['bannerList'] != null) {
      bannerList = new List<BannerListItem>();
      json['bannerList'].forEach((v) {
        bannerList.add(new BannerListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerListItem {
  String icon;
  String url;

  BannerListItem({this.icon, this.url});

  BannerListItem.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['url'] = this.url;
    return data;
  }
}