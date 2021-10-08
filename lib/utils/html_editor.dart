import 'dart:convert';

import 'package:demo7_pro/json/enum_info_entity.dart';

import 'package:demo7_pro/json/template_variable_type_entity.dart';
import 'package:demo7_pro/generated/json/base/json_convert_content.dart';

import 'package:demo7_pro/utils/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_character_entities/html_character_entities.dart';

class HtmlEditorUtils {
  // 转换HTML 到后端编辑器格式 <input class="${variableNo} %{variable_type}" placeholder="variable_name" />
  static String convertHtmlToBoss(String html) {
    html = html.replaceAllMapped(
        RegExp(r'<span[^>]*data-data=([^>]*)[^>]*>',
            caseSensitive: false, multiLine: true), (match) {
      if (match.groupCount < 1) {
        return match.input;
      }

      Map<String, dynamic> variableInfo = jsonDecode(match.group(1));
      var variable =
          JsonConvert.fromJsonAsT<TemplateVariableTypeEntity>(variableInfo);
      return getVariableHtmlBoss(variable);
    });
    return html;
  }

  // 转换HTML 到 手机端编辑器格式 <span> </span><span class="editor-variable" data-no="${variable.variableNo}" data-data=$data>{${variable.variableName}}</span><span> </span>
  static String convertHtmlFromBoss(
      String html, List<TemplateVariableTypeEntity> variables,
      {bool generateNo = false}) {
    html = html.replaceAllMapped(
        RegExp(r'(<input[^>]*>)', caseSensitive: false, multiLine: true),
        (match) {
      if (match.groupCount < 1) {
        return match.input;
      }
      var inputHtml = match.group(1);

      var cls = RegExp(r'class="([^"]*)"').firstMatch(inputHtml).group(1);

      var variableNo = RegExp(r'\$\{([^}]*)\}').firstMatch(cls).group(1);

      var variable =
          variables.firstWhere((element) => element.variableNo == variableNo);
      if (generateNo) {
        variable.variableNo =
            "${DateTime.now().millisecondsSinceEpoch + match.start}";
      }
      return getVariableHtml(variable);
    });
    return html;
  }

  // 获取变量 HTML
  static String getVariableHtml(TemplateVariableTypeEntity variable) {
    String data = jsonEncode(variable.toJson());
    data = HtmlCharacterEntities.encode(data);
    return """<span> </span><span class="editor-variable" data-no="${variable.variableNo}" data-data="$data">{${variable.variableName}}</span><span> </span>""";
  }

  // 获取变量 HTML （BOSS）
  static String getVariableHtmlBoss(TemplateVariableTypeEntity variable) {
    return """<input class="\${${variable.variableNo}} %{${variable.variableType.toLowerCase()}" placeholder="${variable.variableName}" disabled="disabled" type="text />""";
  }

  // 获取HTML 中的变量列表
  static Future<List<TemplateVariableTypeEntity>> getVariableFromHtml(
      String html) async {
    List<String> variableList = RegExp(r'<span[^>]*data-data="([^>]*)"[^>]*>',
            caseSensitive: false, multiLine: true)
        .allMatches(html)
        .toList()
        .map((e) => e.group(1))
        .map((e) => HtmlCharacterEntities.decode(e))
        .toList();

    return variableList.map((e) {
      Map<String, dynamic> jsonMap = jsonDecode(e);
      return JsonConvert.fromJsonAsT<TemplateVariableTypeEntity>(jsonMap);
    }).toList();
  }

  // 获取HTML 中的变量列表
  static Future<List<TemplateVariableTypeEntity>> getVariableFromController(
      HtmlEditorController controller) async {
    List<dynamic> variableList =
        await controller.editorController.evaluateJavascript(source: """
       [...document.querySelectorAll(`.editor-variable[data-no]`)].map((el)=>{
          if(el.innerText == null || el.innerText.trim() == ``){
            el.remove();
            return null;
          }
          var data =  el.getAttribute(`data-data`);
          return data;
       });
      """);

    return variableList.where((element) => element != null).map((e) {
      Map<String, dynamic> jsonMap = jsonDecode(e);
      return JsonConvert.fromJsonAsT<TemplateVariableTypeEntity>(jsonMap);
    }).toList();
  }

  // 更新编辑器HTML 变量
  static Future updateVariableHtml(HtmlEditorController controller,
      TemplateVariableTypeEntity variable) async {
    if (controller == null || controller.editorController == null) {
      return;
    }
    await controller.editorController.evaluateJavascript(source: """
       var elList = document.querySelectorAll(`.editor-variable[data-no]`);
       for(el of elList){
          if(el.getAttribute(`data-no`) === `${variable.variableNo}`){
            el.setAttribute(`data-no`, `${variable.variableNo}`);
            el.setAttribute(`data-data`, `${jsonEncode(variable.toJson())}`);
            el.innerHTML = el.innerHTML.replace(/\{.+\}/ig,`{${variable.variableName}}`);
        }
       }
      """);

    controller.insertHtml("");
  }

  // 变量编辑
  static Future ensureVariableEditable(HtmlEditorController controller) async {
    if (controller == null || controller.editorController == null) {
      return;
    }
    return await controller.editorController.evaluateJavascript(source: """
                                      document.addEventListener(`click`, (e)=>{
                                        var el = e.target;
                                        while(el && !el.classList.contains(`editor-variable`)){
                                          el = el.parentElement;
                                        }
                                        if(!el){
                                          return;
                                        }
                                        var variableData = el.getAttribute(`data-data`);
                                        console.log(variableData);
                                        window.flutter_inappwebview.callHandler(`jsEditVariable`, variableData);
                                      });
                                      
                                      
                                      const observer = new MutationObserver((mutationsList, observer)=>{
                                        for(var mutation of mutationsList){
                                     
                                          let { target, type, removedNodes}  = mutation;
                                            
                                        
                                          if([`characterData`].includes(type)){
                                            let el = target;
                                    
                                            while(el && el.constructor !== HTMLSpanElement){
                                              el = el.parentElement;
                                            }
                                          
                                            if(!el || !el.classList || !el.classList.contains(`editor-variable`)){
                                              continue;
                                            }
                                            console.log('利用原生mutationObserver监听dom节点变化，把删掉的节点移除掉');
                                                     console.log('变化1',target,JSON.stringify(target));
                                              console.log('变化2',type);
                                               console.log('变化3' ,JSON.stringify(removedNodes));
                                           console.log('变化1111',el,JSON.stringify(el));
                                            var variableNo = el.getAttribute(`data-no`);
                                            document.querySelectorAll(`.editor-variable[data-no="`+ variableNo +`"]`).forEach(e=>{
                                              e.remove();
                                            });
                                          }
                                        }
                                      });
                                      
                                      observer.observe(document.querySelector(`[contenteditable]`), { attributes: true, childList: true, subtree: true,characterDataOldValue:true, characterData: true });
                                      
                                      """);
  }

  // 输入文档名称弹窗
  static Future<String> showNameConfirm(BuildContext context,
      {String name = ""}) async {
    TextEditingController textEditingController =
        TextEditingController(text: name);
    String value = await showDialog<String>(
      context: context,
      builder: (_) => WillPopScope(
        child: AlertDialog(
          title: Text("请输入文档名称"),
          content: Container(
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,
              style: TextStyle(fontSize: 14.0),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: '文档名称',
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              controller: textEditingController,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.pop(context, null),
            ),
            TextButton(
              child: Text('确定'),
              onPressed: () async {
                if (textEditingController.text.trim().isEmpty) {
                  AppUtil.showToast("请输入文档名称");
                  return;
                }
                Navigator.pop(context, textEditingController.text);
              },
            ),
          ],
        ),
        onWillPop: () async {
          Navigator.pop(context, null);
          return true;
        },
      ),
    );

    return value;
  }

  // 插入或编辑变量
  static Future<TemplateVariableTypeEntity> editVariable(
      BuildContext context, List<TemplateVariableTypeEntity> variableTypeList,
      {TemplateVariableTypeEntity variable}) async {
    if (variableTypeList.isEmpty) {
      return null;
    }
    if (variable == null) {
      var firstVariable = variableTypeList.first;
      variable = TemplateVariableTypeEntity()
        ..variableNo = "${DateTime.now().millisecondsSinceEpoch}"
        ..variableName = ""
        ..variableCategoryType = firstVariable.variableCategoryType
        ..required = "true"
        ..variableType = firstVariable.variableType;
    }

    TextEditingController textEditingController =
        TextEditingController(text: variable.variableName);

    var createLabel = (String label) {
      return Container(
        margin: EdgeInsets.only(top: 15),
        child: Text(label, style: TextStyle(fontSize: 12, color: Colors.black)),
      );
    };

    TemplateVariableTypeEntity value =
        await showDialog<TemplateVariableTypeEntity>(
      context: context,
      builder: (_) => WillPopScope(
        child: AlertDialog(
          title: Text("变量信息"),
          content: Scrollbar(
            isAlwaysShown: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createLabel("变量名称"),
                        TextField(
                          autofocus: true,
                          cursorColor: Theme.of(context).primaryColor,
                          style: TextStyle(fontSize: 14.0),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: '请输入变量名称',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
                          controller: textEditingController,
                        ),
                        createLabel("变量分类"),
                        Container(
                          constraints:
                              BoxConstraints(minWidth: double.infinity),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: Colors.grey,
                          ))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                    child: DropdownButton<EnumInfoEntity>(
                                  value:
                                      TemplateVariableCategoryList.firstWhere(
                                          (element) =>
                                              element.value ==
                                              variable.variableCategoryType),
                                  iconSize: 24,
                                  underline: Container(height: 0),
                                  onChanged: (EnumInfoEntity newValue) {
                                    variable.variableCategoryType =
                                        newValue.value;
                                    setState(() => {});
                                  },
                                  items: TemplateVariableCategoryList.map<
                                          DropdownMenuItem<EnumInfoEntity>>(
                                      (EnumInfoEntity value) {
                                    return DropdownMenuItem<EnumInfoEntity>(
                                      value: value,
                                      child: Container(
                                        child: Text(
                                          value.displayName,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )),
                              )
                            ],
                          ),
                        ),
                        createLabel("变量类型"),
                        Builder(
                          builder: (BuildContext context) {
                            var typeList = variableTypeList
                                .where((element) =>
                                    element.variableCategoryType ==
                                    variable.variableCategoryType)
                                .toList();
                            if (!typeList.any((element) =>
                                element.variableType ==
                                variable.variableType)) {
                              variable.variableType =
                                  typeList.first.variableType;
                            }
                            return Container(
                              constraints:
                                  BoxConstraints(minWidth: double.infinity),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.grey,
                              ))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        child: DropdownButton<
                                            TemplateVariableTypeEntity>(
                                      value: typeList.firstWhere(
                                          (element) =>
                                              element.variableType ==
                                              variable.variableType,
                                          orElse: () => null),
                                      iconSize: 24,
                                      underline: Container(height: 0),
                                      onChanged: (TemplateVariableTypeEntity
                                          newValue) {
                                        variable.variableType =
                                            newValue.variableType;
                                        setState(() => {});
                                      },
                                      items: typeList.map<
                                              DropdownMenuItem<
                                                  TemplateVariableTypeEntity>>(
                                          (TemplateVariableTypeEntity value) {
                                        return DropdownMenuItem<
                                            TemplateVariableTypeEntity>(
                                          value: value,
                                          child: Container(
                                            child: Text(
                                              value.variableName,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        createLabel("是否为必填"),
                        Container(
                          height: 5,
                        ),
                        Container(
                          constraints:
                              BoxConstraints(minWidth: double.infinity),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: Colors.grey,
                          ))),
                          child: Row(
                            children: [
                              Container(
                                  child: CupertinoSwitch(
                                onChanged: (bool value) {
                                  variable.required = value ? "true" : "false";
                                  setState(() => {});
                                },
                                value: variable.required == "true",
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.pop(context, null),
            ),
            TextButton(
              child: Text('确定'),
              onPressed: () async {
                if (textEditingController.text.trim().isEmpty) {
                  AppUtil.showToast("请输入变量名称");
                  return;
                }
                var variableName = textEditingController.text;
                variable.variableName = variableName;
                Navigator.pop(context, variable);
              },
            ),
          ],
        ),
        onWillPop: () async {
          Navigator.pop(context, null);
          return true;
        },
      ),
    );

    return value;
  }
}
