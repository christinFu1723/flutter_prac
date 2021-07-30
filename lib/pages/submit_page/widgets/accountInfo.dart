import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/title.dart' show TitleSpan;
import 'package:demo7_pro/utils/validate.dart' show ValidateUtil;
import 'package:demo7_pro/dto/companyInfo.dart' show CompanyInfo;
import 'package:logger/logger.dart';
import 'package:demo7_pro/widgets/common/input.dart' show InputForm;
import 'package:demo7_pro/widgets/common/inputDecoration.dart'
    show InputStyleDecoration;

class AccountInfoSubmit extends StatefulWidget {
  final Function onNextStep;
  final CompanyInfo form;

  @override
  AccountInfoSubmit({Key key, this.onNextStep, this.form}) : super(key: key);

  @override
  _AccountInfoSubmitState createState() => _AccountInfoSubmitState();
}

class _AccountInfoSubmitState extends State<AccountInfoSubmit>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController organizeAccountNameController;
  TextEditingController organizeAccountMobileController;
  TextEditingController positionController;
  CompanyInfo form;

  @override
  bool get wantKeepAlive => true; // 防止页面tab切换以后，页面重绘

  @override
  initState() {
    Logger().i('查看页面是否重绘');
    form = widget.form;
    organizeAccountNameController = TextEditingController();
    organizeAccountMobileController = TextEditingController();
    positionController = TextEditingController();

    super.initState();
  }

  @override
  dispose() {
    organizeAccountNameController?.dispose();
    organizeAccountMobileController?.dispose();
    positionController?.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return SizedBox(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _accountInfoForm(),
            _nextBtn(),
          ],
        ),
      ),
    );
  }

  Widget _nextBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (form.validateAccount()) {
            widget.onNextStep.call();
          }
        },
        child: const Text('下一步'),
      ),
    );
  }

  Widget _accountInfoForm() {
    return Column(children: [
      TitleSpan(title: '管理员账号'),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      ),
      Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            InputStyleDecoration(
              '管理员名称',
              InputForm(
                  controller: organizeAccountNameController,
                  initVal: form.organizeAccountName,
                  validatorFn: (
                    String value,
                  ) {
                    return _inputValidate(value,
                        validateType: '', errMsg: '请输入管理员名称');
                  },
                  onChange: (String value) {
                    // organizeAccountNameController.text = value;
                    form.organizeAccountName = value;
                  },
                  hintStr: '请输入管理员名称',
                  maxLength: 10),
              showRequireFlg: true,
            ),
            InputStyleDecoration(
              '管理员手机号',
              InputForm(
                  controller: organizeAccountMobileController,
                  initVal: form.organizeAccountMobile,
                  validatorFn: (
                    String value,
                  ) {
                    return _inputValidate(value,
                        validateType: 'mobile', errMsg: '请输入管理员手机号');
                  },
                  onChange: (String value) {
                    form.organizeAccountMobile = value;
                  },
                  hintStr: '请输入管理员手机号',
                  maxLength: 11,
                  keyboardType: TextInputType.phone),
              showRequireFlg: true,
            ),
            InputStyleDecoration(
              '管理员职位名称',
              InputForm(
                  controller: positionController,
                  initVal: form.position,
                  validatorFn: (
                    String value,
                  ) {
                    return _inputValidate(value,
                        validateType: '', errMsg: '请输入管理员职位名称');
                  },
                  onChange: (String value) {
                    form.position = value;
                  },
                  hintStr: '请输入管理员职位名称',
                  maxLength: 10),
            ),
          ],
        ),
      )
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
        if (value == '' || value == null) {
          return errMsg;
        }
        break;
    }
    return '';
  }
}
