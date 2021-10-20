import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/title.dart' show TitleSpan;
import 'package:demo7_pro/config/theme.dart' show AppTheme;
import 'package:demo7_pro/utils/validate.dart' show ValidateUtil;
import 'package:demo7_pro/dto/company_info.dart' show CompanyInfo;
import 'package:logger/logger.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:demo7_pro/utils/time.dart' show TimeUtil;
import 'package:demo7_pro/widgets/common/input.dart' show InputForm;
import 'package:demo7_pro/widgets/common/input_decoration.dart'
    show InputStyleDecoration;
import 'package:demo7_pro/widgets/common/checkbox_group.dart' show CheckBoxGroup;

class PackageChoose extends StatefulWidget {
  final Function onNextStep;
  final CompanyInfo form;

  @override
  PackageChoose({Key key, this.onNextStep, this.form}) : super(key: key);

  @override
  _PackageChooseState createState() => _PackageChooseState();
}

class _PackageChooseState extends State<PackageChoose>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController effectiveDateController;
  TextEditingController expireDateController;

  CompanyInfo form;

  List<Map<String, dynamic>> checkboxGroup = [
    {'title': '智能视频', 'value': '0001', 'contractedPrice': '0'},
    {'title': '电子合同', 'value': '0002', 'contractedPrice': '0'}
  ];

  @override
  bool get wantKeepAlive => true; // 防止页面tab切换以后，页面重绘

  @override
  initState() {
    form = widget.form;

    effectiveDateController = TextEditingController();
    expireDateController = TextEditingController();

    super.initState();
  }

  @override
  dispose() {
    effectiveDateController?.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return SizedBox(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _companyInfoForm(),
            _packagesForm(),
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
          if (form.validatePackagesChoose()) {
            widget.onNextStep.call();
          }
        },
        child: const Text('下一步'),
      ),
    );
  }

  Widget _packagesForm() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      ),
      TitleSpan(title: '套餐选择'),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      ),
      Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6)),
          child: CheckBoxGroup(
            group: checkboxGroup,
            handleGroupChange: groupChangeCb,
            childCreateFn: packagesPrices,
          ))
    ]);
  }

  Widget packagesPrices(
      Map<String, dynamic> item,
      List<Map<String, dynamic>> group,
      int index,
      Function(List<Map<String, dynamic>> group) handleGroupChange) {
    return Container(
      width: 80,
      height: 36,
      decoration: BoxDecoration(
          color: item['selected'] == 'true'
              ? Colors.white
              : AppTheme.placeholderColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: item['selected'] == 'true'
                  ? AppTheme.secondColor.withOpacity(0.5)
                  : Colors.transparent)),
      child: InputForm(
          readOnly: item['selected'] == 'true' ? false : true,
          textAlign: TextAlign.center,
          controller: item['controller'] is TextEditingController
              ? item['controller']
              : null,
          initVal: item['contractedPrice'] ?? '0',
          keyboardType: TextInputType.number,
          validatorFn: (
            String value,
          ) {
            return _inputValidate(value, validateType: '', errMsg: '请输入');
          },
          onChange: (String value) {
            try {
              setState(() {
                group[index]['contractedPrice'] = value;
              });
              handleGroupChange(group); // 传递出数组变化
            } catch (e) {
              Logger().e(e);
            }
          },
          hintStr: '请输入',
          maxLength: 10),
    );
  }

  void groupChangeCb(List<Map<String, dynamic>> group) {
    if(group is List<Map<String,dynamic>>){
      var arr = [];
      for(var item in group){
        if(item['selected']=='true'){
          arr.add({
            'productNo':item['value'],
            'contractedPrice':item['contractedPrice']??'0',
            'giftContractFlag':item['giftContractFlag']??'N'
          });
        }

      }
      form.products=arr;
      Logger().i('最终存入的：${form.products}');
    }
  }

  Widget _companyInfoForm() {
    return Column(children: [
      TitleSpan(title: '合同期限'),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      ),
      Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Column(
          children: [
            InputStyleDecoration(
                '合同起始日期',
                InputForm(
                  controller: effectiveDateController,
                  initVal: form.effectiveDate,
                  validatorFn: (
                    String value,
                  ) {
                    return _inputValidate(value,
                        validateType: 'mobile', errMsg: '请选择合同起始日期');
                  },
                  readOnly: true,
                  onTap: () async {
                    Logger().i(form.effectiveDate != null
                        ? DateTime.parse(form.effectiveDate)
                        : DateTime.now());
                    DateTime newDateTime = await showRoundedDatePicker(
                      context: context,
                      locale: Locale("zh", "CN"),
                      initialDate: form.effectiveDate != null
                          ? DateTime.parse(form.effectiveDate)
                          : DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                      borderRadius: 16,
                    );

                    var dateStr = TimeUtil.DateTime2YMD(newDateTime);
                    effectiveDateController.text = dateStr;
                    form.effectiveDate = dateStr;
                  },
                  onChange: (String value) {},
                  hintStr: '请选择合同起始日期',
                ),
                showRequireFlg: true,
                extendsWidget: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.date_range_sharp))),
            InputStyleDecoration(
                '合同终止日期',
                InputForm(
                  controller: expireDateController,
                  initVal: form.expireDate,
                  validatorFn: (
                    String value,
                  ) {
                    return _inputValidate(value,
                        validateType: 'mobile', errMsg: '请选择合同终止日期');
                  },
                  readOnly: true,
                  onTap: () async {
                    Logger().i(form.expireDate != null
                        ? DateTime.parse(form.expireDate)
                        : DateTime.now());
                    DateTime newDateTime = await showRoundedDatePicker(
                      context: context,
                      locale: Locale("zh", "CN"),
                      initialDate: form.expireDate != null
                          ? DateTime.parse(form.expireDate)
                          : DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                      borderRadius: 16,
                    );

                    var dateStr = TimeUtil.DateTime2YMD(newDateTime);
                    expireDateController.text = dateStr;
                    form.expireDate = dateStr;
                  },
                  onChange: (String value) {},
                  hintStr: '请选择合同终止日期',
                ),
                showRequireFlg: true,
                extendsWidget: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.date_range_sharp))),
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
