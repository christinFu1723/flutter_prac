import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
const Catch_urls = ['m.ctrip.com/','m.ctrip.com/html5/','m.ctrip.com/html5']; // 白名单

class WebView extends StatefulWidget {
  final String url;
  final String statusBar;
  final String title;
  final bool hideAppBar;
  final bool backForbid;


  WebView({this.url,this.statusBar,this.backForbid=false,this.hideAppBar,this.title});


  @override
  _WebViewState createState()=>_WebViewState();
}

class _WebViewState extends State<WebView>{
  final webviewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webviewReference.close();
    _onUrlChanged = webviewReference.onUrlChanged.listen((String url) {

    });
    _onStateChanged = webviewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch(state.type){
        case WebViewState.startLoad:
          if(_isToMainPage(state.url)&& !exiting){
            if(widget.backForbid){
              // 禁止返回
              webviewReference.launch(widget.url);
            } else{
              Navigator.pop(context);
              exiting = true; // 禁止重复返回
            }
          }
          break;
        default:break;
      }
    });
    _onHttpError = webviewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose()

    _onHttpError.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    webviewReference.dispose();
    super.dispose();
  }
  @override
  Widget  build(BuildContext context){
    String statusBarColorStr = widget.statusBar??'ffffff';
    Color backButtonColor;
    if(statusBarColorStr == 'ffffff'){
      backButtonColor=Colors.black;
    } else{
      backButtonColor=Colors.white;
    }
    return Scaffold(
      body: Column(
        children:[
          FractionallySizedBox(widthFactor: 1,child: _appBar(Color(int.parse('0xff$statusBarColorStr')),backButtonColor)),
          Expanded(
            child:WebviewScaffold(
              url:widget.url,
              withZoom: true, // 允许缩放
              withLocalStorage: true,
              hidden: true,
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text('waiting...'),
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _appBar(Color backgroundColor,Color backButtonColor){
    if(widget.hideAppBar??false){
      // widget.hideAppBar??false
      // 如果widget.hideAppBar等于null,则返回false,
      // 如果widget.hideAppBar不等于null,不做任何处理,
      return Container(
        color:backgroundColor,
        height: 30,
          // child: Text(
          //     '隐藏appBar',
          //     style:TextStyle(color: backgroundColor,fontSize: 20)
          // )
      );
    } else{
      return Container(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
        color: backgroundColor,
        child:FractionallySizedBox(
          widthFactor: 1,
          child: Stack(
            children: [
              GestureDetector(
                onTap:(){
                  Navigator.pop(context);
                },
                child: Container(
                  margin:EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.close,
                    color: backButtonColor,
                    size: 26,
                  ),

                ),
              ),
              Positioned(
                  left:0,
                  right:0,
                  child: Center(
                    child: Text(
                        widget.title!=null?'我是-${widget.title}':'',
                      style:TextStyle(color: Colors.black,fontSize: 20)
                    )

              ))
            ],
          ),
        ),
      );
    }
  }

  bool _isToMainPage(String url){
    bool contain=false;
    for(final val in Catch_urls){
      if(url?.endsWith(val)??false){
          contain = true;
          break;
      }
    }
    return contain;
  }
}

