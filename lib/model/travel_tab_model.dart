class TravelTabModel {
  String url;
  TravelParams params;
  List<TravelTabs> tabs;

  TravelTabModel({this.url, this.params, this.tabs});

  TravelTabModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    params =
    json['params'] != null ? new TravelParams.fromJson(json['params']) : null;
    if (json['tabs'] != null) {
      tabs = new List<TravelTabs>();
      json['tabs'].forEach((v) {
        tabs.add(new TravelTabs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    if (this.params != null) {
      data['params'] = this.params.toJson();
    }
    if (this.tabs != null) {
      data['tabs'] = this.tabs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TravelParams {
  int districtId;
  String groupChannelCode;
  Null type;
  int lat;
  int lon;
  int locatedDistrictId;
  PagePara pagePara;
  int imageCutType;
  TravelHead head;
  String contentType;

  TravelParams(
      {this.districtId,
        this.groupChannelCode,
        this.type,
        this.lat,
        this.lon,
        this.locatedDistrictId,
        this.pagePara,
        this.imageCutType,
        this.head,
        this.contentType});

  TravelParams.fromJson(Map<String, dynamic> json) {
    districtId = json['districtId'];
    groupChannelCode = json['groupChannelCode'];
    type = json['type'];
    lat = json['lat'];
    lon = json['lon'];
    locatedDistrictId = json['locatedDistrictId'];
    pagePara = json['pagePara'] != null
        ? new PagePara.fromJson(json['pagePara'])
        : null;
    imageCutType = json['imageCutType'];
    head = json['head'] != null ? new TravelHead.fromJson(json['head']) : null;
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtId'] = this.districtId;
    data['groupChannelCode'] = this.groupChannelCode;
    data['type'] = this.type;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['locatedDistrictId'] = this.locatedDistrictId;
    if (this.pagePara != null) {
      data['pagePara'] = this.pagePara.toJson();
    }
    data['imageCutType'] = this.imageCutType;
    if (this.head != null) {
      data['head'] = this.head.toJson();
    }
    data['contentType'] = this.contentType;
    return data;
  }
}

class PagePara {
  int pageIndex;
  int pageSize;
  int sortType;
  int sortDirection;

  PagePara({this.pageIndex, this.pageSize, this.sortType, this.sortDirection});

  PagePara.fromJson(Map<String, dynamic> json) {
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    sortType = json['sortType'];
    sortDirection = json['sortDirection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageIndex'] = this.pageIndex;
    data['pageSize'] = this.pageSize;
    data['sortType'] = this.sortType;
    data['sortDirection'] = this.sortDirection;
    return data;
  }
}

class TravelHead {
  String cid;
  String ctok;
  String cver;
  String lang;
  String sid;
  String syscode;
  Null auth;
  List<TravelExtension> extension;

  TravelHead(
      {this.cid,
        this.ctok,
        this.cver,
        this.lang,
        this.sid,
        this.syscode,
        this.auth,
        this.extension});

  TravelHead.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    ctok = json['ctok'];
    cver = json['cver'];
    lang = json['lang'];
    sid = json['sid'];
    syscode = json['syscode'];
    auth = json['auth'];
    if (json['extension'] != null) {
      extension = new List<TravelExtension>();
      json['extension'].forEach((v) {
        extension.add(new TravelExtension.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['ctok'] = this.ctok;
    data['cver'] = this.cver;
    data['lang'] = this.lang;
    data['sid'] = this.sid;
    data['syscode'] = this.syscode;
    data['auth'] = this.auth;
    if (this.extension != null) {
      data['extension'] = this.extension.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TravelExtension {
  String name;
  String value;

  TravelExtension({this.name, this.value});

  TravelExtension.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class TravelTabs {
  String labelName;
  String groupChannelCode;

  TravelTabs({this.labelName, this.groupChannelCode});

  TravelTabs.fromJson(Map<String, dynamic> json) {
    labelName = json['labelName'];
    groupChannelCode = json['groupChannelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labelName'] = this.labelName;
    data['groupChannelCode'] = this.groupChannelCode;
    return data;
  }
}
