import 'package:flutter/material.dart';
import 'package:demo7_pro/model/common_model.dart';
import 'package:demo7_pro/widgets/webview.dart';

class SubNav extends StatelessWidget{
  final List<CommonModel> subNavList;
  const SubNav({Key key,@required this.subNavList}):super(key:key);
  Widget build (BuildContext context){
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }
  Widget _items(BuildContext context){
    if(subNavList==null) return null;
    List<Widget> items=[];
    subNavList.forEach((model){
      items.add(_item(context,model));
    });
    int separate = (subNavList.length / 2 + 0.5).toInt();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0,separate),
        ),
        Padding(padding: EdgeInsets.only(top:10),
          child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate,subNavList.length),
          ),
        )
      ],
    );
  }
  Widget _item(BuildContext context,CommonModel model){
    return Expanded(child: GestureDetector(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>WebView(
            url: model.url,
            statusBar: model.statusBarColor,
            hideAppBar: model.hideAppBar,

          )));
        },
        child:Column(
          children: [
            Image.network(model.icon,width: 18,height: 18),
            Padding(padding:
            EdgeInsets.only(top:3),
                child:Text(model.title,style: TextStyle(fontSize: 12),
                ))

          ],
        )
    ));
  }
}