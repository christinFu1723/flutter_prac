import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/timeline.dart' show StepTimeline;
import 'package:demo7_pro/config/theme.dart' show AppTheme;
import 'package:demo7_pro/pages/submit_page/widgets/company_info.dart'
    show CompanyInfoSubmit;
import 'package:demo7_pro/pages/submit_page/widgets/account_info.dart'
    show AccountInfoSubmit;
import 'package:demo7_pro/pages/submit_page/widgets/package_choose.dart'
    show PackageChoose;
import 'package:logger/logger.dart';
import 'package:demo7_pro/dto/company_info.dart' show CompanyInfo;
import 'package:demo7_pro/route/route_util.dart' show pop;

class SubmitPage extends StatefulWidget {
  @override
  _SubmitPageState createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> with TickerProviderStateMixin {
  int nowStep = 2;
  final List<String> timeline = ['信息录入', '主账号创建', '套餐选择'];
  TabController _tabController;
  CompanyInfo form;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(this.nowStep);
    form = CompanyInfo();
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              stretch: false,
              forceElevated: true,
              leading: GestureDetector(
                onTap: () {
                  pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: AppTheme.placeholderColor,
                ),
              ),
              // flexibleSpace: Image.network(
              //   'https://hbimg.huabanimg.com/89b90b7944a97b9f2f19c947be71dd9ae1bbf49040e45a-rt5p7S_fw658/format/webp',
              //   fit: BoxFit.cover,
              // ),
              toolbarHeight: 45,

              expandedHeight: 200,

              bottom: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: Column(
                  children: [_step(), _tab()],
                ),
              ),
            ),
          ];
        },
        body: _tabPage(),
      );
    }));
  }

  Widget _tabPage() {
    return Container(
        padding: EdgeInsets.all(20),
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            SingleChildScrollView(
              child: CompanyInfoSubmit(
                  form: this.form,
                  onNextStep: () => {_handleNextStepDone(nextStep: 1)}),
              padding: EdgeInsets.symmetric(vertical: 10),
              physics: NeverScrollableScrollPhysics(),
            ),
            SingleChildScrollView(
              child: AccountInfoSubmit(
                  form: this.form,
                  onNextStep: () => {_handleNextStepDone(nextStep: 2)}),
              padding: EdgeInsets.symmetric(vertical: 10),
              physics: NeverScrollableScrollPhysics(),
            ),
            SingleChildScrollView(
              child: PackageChoose(
                  form: this.form,
                  onNextStep: () => {_handleNextStepDone(nextStep: 3)}),
              padding: EdgeInsets.symmetric(vertical: 10),
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ));
  }

  Widget _tab() {
    return TabBar(
      controller: _tabController,
      unselectedLabelColor: AppTheme.placeholderColor,
      labelColor: AppTheme.secondColor,
      indicatorColor: AppTheme.secondColor,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.label,
      onTap: (index) {
        _handleNextStepDone(nextStep: index);
      },
      tabs: <Widget>[
        Tab(
          child: Text(
            '基本信息',
          ),
        ),
        Tab(
          child: Text(
            '账号信息',
          ),
        ),
        Tab(
          child: Text(
            '套餐信息',
          ),
        ),
      ],
    );
  }

  Widget _step() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 18, 0, 20),
            child: Container(
                alignment: Alignment.center,
                child: StepTimeline(
                    data: timeline,
                    nowStep: this.nowStep,
                    handleTimelineIndicatorTap: _handleNextStep))));
  }

  _handleNextStep(int nextStep) {
    _handleNextStepDone(nextStep: nextStep);
  }

  _handleNextStepDone({@required int nextStep}) {
    if (nextStep >= timeline.length) {
      return;
    }
    _tabController.index = nextStep;
    // _tabController.animateTo(nextStep, duration: Duration(milliseconds: 20),curve: Curves.easeIn);
    setState(() {
      this.nowStep = nextStep;
    });
  }
}
