import 'dart:async';

import 'package:demo7_pro/eventBus/app.dart';
import 'package:demo7_pro/services/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/search_bar.dart';
import 'package:demo7_pro/route/pages/webview/index.dart'
    show WebviewPageRoutes;
import 'package:demo7_pro/route/pages/speak_page//index.dart'
    show SpeakPageRoutes;
import 'package:demo7_pro/route/route_util.dart' show navTo;
import 'package:demo7_pro/dao/search_dao.dart';
import 'package:demo7_pro/model/search_model.dart';
import 'package:logger/logger.dart';
import 'dart:math';

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage(
      {Key key,
      this.hideLeft = true,
      this.searchUrl = baseUrl,
      this.keyword,
      this.hint});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  String showText = '';
  String keyword;
  SearchModel searchModel;
  final FocusNode focusNode = FocusNode();

  StreamSubscription _homeTabChangeEvent;

  // @override
  // bool get wantKeepAlive =>true;

  @override
  void initState() {
    super.initState();

    if (widget.keyword != null) {
      _textChange(widget.keyword);
    }
    _homeTabChangeEvent =
        EventBusService.eventBus.on<HomeTabChangeEvent>().listen((event) {
      if (event.index != 1) {
        focusNode.unfocus(); // 失去焦点
      } else {
        focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _homeTabChangeEvent?.cancel();
    focusNode.unfocus(); // 失去焦点
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _appBar(),
        MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(
                flex: 1,
                child: ListView.builder(
                    itemCount: searchModel?.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int pos) {
                      return _listViewItem(pos);
                    })))
      ],
    ));
  }

  _textChange(text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + text;
    // SearchDao.fetch(url:url,keyword:keyword)
    SearchDao.fetch(keyword: keyword).then((resp) {
      if (resp['SearchModel']?.keyword == keyword) {
        // 输入内容和服务器返回一致才渲染
        setState(() {
          searchModel = resp['SearchModel'];
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _appBar() {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0x66000000), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Container(
              padding: EdgeInsets.only(top: 20),
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: SearchBar(
                focusNode: focusNode,
                hideLeft: widget.hideLeft,
                defaultText: widget.keyword,
                hint: widget.hint,
                speakClick: _jumpToSpeak,
                autofocus: false,
                leftButtonClick: () {
                  Navigator.pop(context);
                },
                // onChanged: _textChange,
              ),
            )),
      ],
    );
  }

  _listViewItem(pos) {
    if (searchModel == null ||
        searchModel.data == null ||
        searchModel.data.length < 1) return null;
    SearchModelItem item = searchModel.data[pos];
    return GestureDetector(
      onTap: () {
        navTo(context, "${WebviewPageRoutes.webview}",
            arguments: {"url": item.url, "title": '详情'});
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                    width: 300,
                    margin: EdgeInsets.only(top: 5),
                    child: _subTitle(item))
              ],
            )
          ],
        ),
      ),
    );
  }

  _jumpToSpeak() {
    navTo(context, "${SpeakPageRoutes.speak}");
  }

  _typeImage(String type) {
    if (type != null) {
      var a = new Random().nextInt(2) + 1;
      print('查看图片，image/$a.jpg');
      return 'image/$a.jpg';
    }
    return 'image/3.jpg';
  }

  _title(SearchModelItem item) {
    if (item == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(TextSpan(
        text: ' ${item.districtname ?? ''}',
        style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(text: TextSpan(children: spans));
  }

  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;
    List<String> arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    for (int i = 0; i < arr.length; i++) {
      if ((i + 1) % 2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  _subTitle(SearchModelItem item) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: item.word ?? '',
            style: TextStyle(fontSize: 16, color: Colors.orange)),
        TextSpan(
            text: item.type ?? '',
            style: TextStyle(fontSize: 16, color: Colors.grey))
      ]),
    );
  }
}
