import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/timeline.dart' show StepTimeline;
import 'package:demo7_pro/widgets/title.dart' show TitleSpan;
import 'package:demo7_pro/config/theme.dart' show AppTheme;
import 'package:demo7_pro/utils/validate.dart' show ValidateUtil;
import 'package:demo7_pro/dto/companyInfo.dart' show CompanyInfo;
import 'package:logger/logger.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:demo7_pro/utils/time.dart' show TimeUtil;
import 'package:demo7_pro/widgets/common/input.dart' show InputForm;
import 'package:demo7_pro/widgets/common/inputDecoration.dart'
    show InputStyleDecoration;

// import 'package:demo7_pro/widgets/common/img_upload.dart' show ImgUpload;
// import 'package:image_picker/image_picker.dart' show XFile;
import 'package:demo7_pro/widgets/common/img_upload_decorator.dart';

class SubmitPage extends StatefulWidget {
  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final List<String> timeline = ['信息录入', '主账号创建', '套餐选择'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController organizeNameController;
  TextEditingController organizeSocialCodeController;
  TextEditingController legalNameController;
  TextEditingController legalIdCardNoController;
  TextEditingController legalMobileController;
  TextEditingController organizeRegisteredCapitalController;
  TextEditingController organizeRegisteredTimeController;
  TextEditingController organizeAddressController;
  TextEditingController contactController;
  TextEditingController contactMobileController;
  TextEditingController contactAddressController;
  TextEditingController attachesController;
  CompanyInfo form;

  @override
  initState() {
    form = new CompanyInfo();
    organizeNameController = TextEditingController();
    organizeSocialCodeController = TextEditingController();
    legalNameController = TextEditingController();
    legalIdCardNoController = TextEditingController();
    legalMobileController = TextEditingController();
    organizeRegisteredCapitalController = TextEditingController();
    organizeRegisteredTimeController = TextEditingController();
    organizeAddressController = TextEditingController();
    contactController = TextEditingController();
    contactMobileController = TextEditingController();
    contactAddressController = TextEditingController();
    attachesController = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    organizeNameController?.dispose();
    organizeSocialCodeController?.dispose();
    legalNameController?.dispose();
    legalIdCardNoController?.dispose();
    legalMobileController?.dispose();
    organizeRegisteredCapitalController?.dispose();
    organizeRegisteredTimeController?.dispose();
    organizeAddressController?.dispose();
    contactController?.dispose();
    contactMobileController?.dispose();
    contactAddressController?.dispose();
    attachesController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
        color: AppTheme.backgroundDefaultColor,
        child: Column(
          children: [
            _step(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _companyInfoForm(),
                  _certificateForm(),
                  _contactInfoForm(),
                  _nextBtn(),
                ],
              ),
            )
          ],
        ),
      ));
    }));
  }

  Widget _nextBtn(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Validate will return true if the form is valid, or false if
          // the form is invalid.
          form.validateForm();
          if (_formKey.currentState.validate()) {
            // Process data.
          }
        },
        child: const Text('下一步'),
      ),
    );
  }

  Widget _step() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 18, 0, 20),
            child: Container(
                alignment: Alignment.center,
                child: StepTimeline(data: timeline, nowStep: 1))));
  }

  Widget _companyInfoForm() {
    return Column(children: [
      TitleSpan(title: '企业信息'),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      ),
      Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            InputStyleDecoration(
                '企业名称',
                InputForm(
                    controller: organizeNameController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入企业名称');
                    },
                    onChange: (String value) {
                      // organizeNameController.text = value;
                      form.organizeName = value;
                    },
                    hintStr: '请输入企业名称',
                    maxLength: 10)),
            InputStyleDecoration(
                '社会统一信用代码',
                InputForm(
                    controller: organizeSocialCodeController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入社会统一信用代码');
                    },
                    onChange: (String value) {
                      // organizeSocialCodeController.text = value;
                      form.organizeSocialCode = value;
                    },
                    hintStr: '请输入社会统一信用代码',
                    maxLength: 20)),
            InputStyleDecoration(
                '法定代表人',
                InputForm(
                    controller: legalNameController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入法定代表人');
                    },
                    onChange: (String value) {
                      // legalNameController.text = value;
                      form.legalName = value;
                    },
                    hintStr: '请输入法定代表人',
                    maxLength: 10)),
            InputStyleDecoration(
                '法人手机号',
                InputForm(
                    controller: legalMobileController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: 'mobile', errMsg: '请输入法人手机号');
                    },
                    onChange: (String value) {
                      // legalMobileController.text = value;
                      form.legalMobile = value;
                    },
                    hintStr: '请输入法人手机号',
                    maxLength: 11,
                    keyboardType: TextInputType.phone)),
            InputStyleDecoration(
                '法人身份证号',
                InputForm(
                  controller: legalIdCardNoController,
                  validatorFn: (
                    String value,
                  ) {
                    return _inputValidate(value,
                        validateType: 'id', errMsg: '请输入法人身份证号');
                  },
                  onChange: (String value) {
                    // legalIdCardNoController.text = value;
                    form.legalIdCardNo = value;
                  },
                  hintStr: '请输入法人身份证号',
                  maxLength: 20,
                )),
            InputStyleDecoration(
                '注册资本',
                InputForm(
                    controller: organizeRegisteredCapitalController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入注册资本');
                    },
                    onChange: (String value) {
                      // organizeRegisteredCapitalController.text = value;
                      form.organizeRegisteredCapital = value;
                    },
                    hintStr: '请输入注册资本',
                    maxLength: 8,
                    keyboardType: TextInputType.number),
                extendsWidget: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '万元',
                      style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: AppTheme.titleColor),
                    ))),
            InputStyleDecoration(
                '注册时间',
                InputForm(
                  controller: organizeRegisteredTimeController,
                  validatorFn: (
                    String value,
                  ) {
                    return _inputValidate(value,
                        validateType: 'mobile', errMsg: '请输入注册时间');
                  },
                  readOnly: true,
                  onTap: () async {
                    Logger().i(form.organizeRegisteredTime != null
                        ? DateTime.parse(form.organizeRegisteredTime)
                        : DateTime.now());
                    DateTime newDateTime = await showRoundedDatePicker(
                      context: context,
                      locale: Locale("zh", "CN"),
                      initialDate: form.organizeRegisteredTime != null
                          ? DateTime.parse(form.organizeRegisteredTime)
                          : DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                      borderRadius: 16,
                    );

                    var dateStr = TimeUtil.DateTime2YMD(newDateTime);
                    organizeRegisteredTimeController.text = dateStr;
                    form.organizeRegisteredTime = dateStr;
                  },
                  onChange: (String value) {},
                  hintStr: '请输入注册时间',
                ),
                extendsWidget: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.date_range_sharp))),
            InputStyleDecoration(
                '注册地址',
                InputForm(
                    controller: organizeAddressController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: 'id', errMsg: '请输入注册地址');
                    },
                    onChange: (String value) {
                      // organizeAddressController.text = value;
                      form.organizeAddress = value;
                    },
                    hintStr: '请输入注册地址',
                    maxLength: 30),
                isLastChild: true),
          ],
        ),
      )
    ]);
  }

  Widget _contactInfoForm() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      ),
      TitleSpan(title: '联系人信息'),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      ),
      Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            InputStyleDecoration(
                '联系人',
                InputForm(
                    controller: contactController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入联系人');
                    },
                    onChange: (String value) {
                      // contactController.text = value;
                      form.contact = value;
                    },
                    hintStr: '请输入联系人',
                    maxLength: 10)),
            InputStyleDecoration(
                '联系人手机号',
                InputForm(
                    controller: contactMobileController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: 'mobile', errMsg: '请输入联系人手机号');
                    },
                    onChange: (String value) {
                      // contactMobileController.text = value;
                      form.contactMobile = value;
                    },
                    hintStr: '请输入联系人手机号',
                    maxLength: 11,
                    keyboardType: TextInputType.phone)),
            InputStyleDecoration(
                '联系地址',
                InputForm(
                    controller: contactAddressController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: 'id', errMsg: '请输入联系地址');
                    },
                    onChange: (String value) {
                      // contactAddressController.text = value;
                      form.contactAddress = value;
                    },
                    hintStr: '请输入联系地址',
                    maxLength: 30),
                isLastChild: true),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      ),
    ]);
  }

  Widget _certificateForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        ),
        TitleSpan(title: '证照信息'),
        ImgUploadDecorator(
          maxLength: 1,
          initImgList: [],
            imgListUploadCallback:handleImgChange
        ),
      ],
    );
  }

  void handleImgChange(List<String> imgs){

    var obj={
      'attachType': '1001',
      'attachUrl': imgs[0],
    };
    var saveAttachesArr=[];
    saveAttachesArr.add(obj);
    form.attaches=saveAttachesArr;
    Logger().i('传回来的照片: ${form.attaches}');
  }

  String _inputValidate(String value,
      {@required String validateType, @required String errMsg}) {
    switch (validateType) {
      case 'mobile':
        if (!ValidateUtil.isMobile(value)) {
          return errMsg;
        }
        break;
      case 'id':
        if (!ValidateUtil.isIdCard(value)) {
          return errMsg;
        }
        break;
      default:
        if (value == ''||value == null) {
          return errMsg;
        }
        break;
    }
    return '';
  }
}
