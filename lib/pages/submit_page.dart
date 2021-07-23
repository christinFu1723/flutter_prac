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
                children: [_companyInfoForm(), _contactInfoForm()],
              ),
            )
          ],
        ),
      ));
    }));
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
            _InputRow(
                '企业名称',
                _Input(
                    controller: organizeNameController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入企业名称');
                    },
                    onChange: (String value) {
                      organizeNameController.text = value;
                      form.organizeName = value;
                    },
                    hintStr: '请输入企业名称',
                    maxLength: 10)),
            _InputRow(
                '社会统一信用代码',
                _Input(
                    controller: organizeSocialCodeController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入社会统一信用代码');
                    },
                    onChange: (String value) {
                      organizeSocialCodeController.text = value;
                      form.organizeSocialCode = value;
                    },
                    hintStr: '请输入社会统一信用代码',
                    maxLength: 20)),
            _InputRow(
                '法定代表人',
                _Input(
                    controller: legalNameController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入法定代表人');
                    },
                    onChange: (String value) {
                      legalNameController.text = value;
                      form.legalName = value;
                    },
                    hintStr: '请输入法定代表人',
                    maxLength: 10)),
            _InputRow(
                '法人手机号',
                _Input(
                    controller: legalMobileController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: 'mobile', errMsg: '请输入法人手机号');
                    },
                    onChange: (String value) {
                      legalMobileController.text = value;
                      form.legalMobile = value;
                    },
                    hintStr: '请输入法人手机号',
                    maxLength: 11,
                    keyboardType: TextInputType.phone)),
            _InputRow(
                '法人身份证号',
                _Input(
                  controller: legalIdCardNoController,
                  validatorFn: (
                    String value,
                  ) {
                    return _inputValidate(value,
                        validateType: 'id', errMsg: '请输入法人身份证号');
                  },
                  onChange: (String value) {
                    legalIdCardNoController.text = value;
                    form.legalIdCardNo = value;
                  },
                  hintStr: '请输入法人身份证号',
                  maxLength: 20,
                )),
            _InputRow(
                '注册资本',
                _Input(
                    controller: organizeRegisteredCapitalController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入注册资本');
                    },
                    onChange: (String value) {
                      organizeRegisteredCapitalController.text = value;
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
            _InputRow(
                '注册时间',
                _Input(
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
            _InputRow(
                '注册地址',
                _Input(
                    controller: organizeAddressController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: 'id', errMsg: '请输入注册地址');
                    },
                    onChange: (String value) {
                      organizeAddressController.text = value;
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
            _InputRow(
                '联系人',
                _Input(
                    controller: contactController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: '', errMsg: '请输入联系人');
                    },
                    onChange: (String value) {
                      contactController.text = value;
                      form.contact = value;
                    },
                    hintStr: '请输入联系人',
                    maxLength: 10)),
            _InputRow(
                '联系人手机号',
                _Input(
                    controller: contactMobileController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: 'mobile', errMsg: '请输入联系人手机号');
                    },
                    onChange: (String value) {
                      contactMobileController.text = value;
                      form.contactMobile = value;
                    },
                    hintStr: '请输入联系人手机号',
                    maxLength: 11,
                    keyboardType: TextInputType.phone)),
            _InputRow(
                '联系地址',
                _Input(
                    controller: contactAddressController,
                    validatorFn: (
                      String value,
                    ) {
                      return _inputValidate(value,
                          validateType: 'id', errMsg: '请输入联系地址');
                    },
                    onChange: (String value) {
                      contactAddressController.text = value;
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
        if (value = null) {
          return errMsg;
        }
        break;
    }
    return '';
  }

  /// input装饰器
  Widget _Input({
    @required TextEditingController controller,
    @required Function validatorFn,
    @required Function onChange,
    Function onTap,
    String hintStr,
    int maxLength,
    bool readOnly,
    TextInputType keyboardType,
  }) {
    return TextFormField(
        maxLength: maxLength,
        textAlign: TextAlign.right,
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          counterText: "",
          // 不显示输入框最大字数统计
          border: InputBorder.none,
          hintText: hintStr,
          hintStyle: TextStyle(
              color: AppTheme.placeholderColor,
              fontSize: AppTheme.fontSizeSmall),
          hintTextDirection: TextDirection.rtl,
        ),
        validator: validatorFn,
        onTap: onTap,
        onChanged: onChange);
  }

  /// 表单行_装饰器
  Widget _InputRow(String title, Widget InputChild,
      {isLastChild = false, Widget extendsWidget}) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          border: !isLastChild
              ? Border(
                  bottom: BorderSide(
                      // 设置单侧边框的样式
                      color: AppTheme.backgroundDefaultColor,
                      width: 1,
                      style: BorderStyle.solid))
              : null),
      child: Row(children: [
        Text(
          title,
          style: TextStyle(
              color: AppTheme.titleColor, fontSize: AppTheme.fontSizeSmall),
        ),
        Expanded(child: InputChild),
        extendsWidget ?? Container()
      ]),
    );
  }
}
