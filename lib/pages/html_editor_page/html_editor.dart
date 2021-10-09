import 'dart:convert';


import 'package:demo7_pro/json/template_info_entity.dart';
import 'package:demo7_pro/json/template_variable_type_entity.dart';
import 'package:demo7_pro/generated/json/base/json_convert_content.dart';


import 'package:demo7_pro/utils/html_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:html_editor_enhanced/html_editor.dart';
import 'package:logger/logger.dart';


class HtmlEditorPage extends StatefulWidget {
  final String fileName;
  final String fileUrl;
  final String templateNo;

  HtmlEditorPage({Key key, this.fileName, this.fileUrl, this.templateNo})
      : super(key: key);

  @override
  _HtmlEditorPageState createState() => _HtmlEditorPageState();
}

class _HtmlEditorPageState extends State<HtmlEditorPage>
    with WidgetsBindingObserver {
  double editorHeight = 0;

  TemplateInfoEntity templateInfo;

  HtmlEditorController controller = HtmlEditorController(
      processInputHtml: true,
      processOutputHtml: false,
      processNewLineAsBr: false);


  List<Map<String,dynamic>> jsonDataVariableList = [
    {
      'variableNo': '',
      'variableName': '姓名',
      'variableType': 'TEXT',
      'variableCategoryType': 'CUSTOMIZE',
      'required': true,
      'variableValue': null
    },
    {
      'variableNo': '',
      'variableName': '性别',
      'variableType': 'TEXT',
      'variableCategoryType': 'CUSTOMIZE',
      'required': 'true',
      'variableValue': null
    }
  ];
  Map<String,dynamic> testTemp = {
    'templateName':'文立测试富文本编辑器',
    'templateHtml':'323223',
    'variables':[]
  };

  List<TemplateVariableTypeEntity> variableTypeList = [

  ];


  // 初始化HTML， 编辑和新增
  Future initDocument() async {
    templateInfo= JsonConvert.fromJsonAsT(testTemp);
    variableTypeList=JsonConvert.fromJsonAsT(jsonDataVariableList);
    setState(() {});
    templateInfo.variables.forEach((variable) {
      HtmlEditorUtils.updateVariableHtml(controller, variable);
    });
  }

  @override
  void initState() {
    super.initState();
    this.initDocument();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("模板管理"),
              actions: [
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    child: Text(
                      "保存",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () async {
                    String templateName = await HtmlEditorUtils.showNameConfirm(
                        context,
                        name: templateInfo?.templateName ?? "");
                    if (templateName == null) {
                      return;
                    }
                    templateInfo.templateName = templateName;
                    templateInfo.templateHtml = await controller.getText();
                  },
                )
              ],
            ),
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (BuildContext context) {
                        if (templateInfo == null) {
                          return Container(
                            alignment: Alignment.center,
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Container(
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              if (editorHeight != constraints.maxHeight) {
                                editorHeight = constraints.maxHeight;
                                Future.delayed(Duration(milliseconds: 100), ()  {
                                  if (controller != null) {
                                     controller.resetHeight();
                                  }
                                });
                              }

                              return HtmlEditor(
                                controller: controller,
                                callbacks: Callbacks(
                                    onFocus: () {},
                                    onBlur: () {},
                                    onInit: () {
                                      controller.editorController
                                          .addJavaScriptHandler(
                                          handlerName: "jsEditVariable",
                                          callback: (args) async {
                                            String variableData =
                                                args.first;
                                            Map<String, dynamic>
                                            variableInfo =
                                            jsonDecode(variableData);
                                            var variable =
                                            JsonConvert.fromJsonAsT<
                                                TemplateVariableTypeEntity>(
                                                variableInfo);
                                            var ret = await HtmlEditorUtils
                                                .editVariable(context,
                                                variableTypeList,
                                                variable: variable);
                                            if (ret == null) {
                                              return {};
                                            }
                                            await HtmlEditorUtils
                                                .updateVariableHtml(
                                                controller, variable);
                                            return {};
                                          });

                                      HtmlEditorUtils.ensureVariableEditable(
                                          controller);

                                      templateInfo.variables
                                          .forEach((variable) {
                                        HtmlEditorUtils.updateVariableHtml(
                                            controller, variable);
                                      });

                                      controller.setFullScreen();
                                    }),
                                htmlEditorOptions: HtmlEditorOptions(
                                    hint: "文档内容",
                                    initialText: templateInfo.templateHtml),
                                htmlToolbarOptions: HtmlToolbarOptions(
                                    toolbarType: ToolbarType.nativeScrollable,
                                    separatorWidget: Container(),
                                    toolbarPosition:
                                    ToolbarPosition.belowEditor,
                                    defaultToolbarButtons: [
                                      FontButtons(
                                          clearAll: false,
                                          strikethrough: false,
                                          superscript: false,
                                          subscript: false),
                                      ParagraphButtons(
                                        alignJustify: false,
                                        increaseIndent: false,
                                        decreaseIndent: false,
                                        textDirection: false,
                                        lineHeight: false,
                                        caseConverter: false,
                                      ),
                                      OtherButtons(
                                        fullscreen: false,
                                        codeview: false,
                                        help: false,
                                        copy: false,
                                        paste: false,
                                      ),
                                    ],
                                    customToolbarButtons: [
                                      InkWell(
                                        child: Text("插入变量"),
                                        onTap: () async {
                                          var variable = await HtmlEditorUtils
                                              .editVariable(
                                              context, variableTypeList);
                                          if (variable == null) {
                                            return;
                                          }
                                          controller.insertHtml(
                                              HtmlEditorUtils.getVariableHtml(
                                                  variable));
                                        },
                                      )
                                    ]),
                                otherOptions: OtherOptions(
                                  height: editorHeight,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )),
        onWillPop: () async {
          return true;
        });
  }
}

