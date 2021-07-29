import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;

  late TabController _tabController;

  initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.purple,
              title: Text('Text'),
              pinned: true,
              stretch: true,
              flexibleSpace: Image.network(
                'https://hbimg.huabanimg.com/89b90b7944a97b9f2f19c947be71dd9ae1bbf49040e45a-rt5p7S_fw658/format/webp',
                fit: BoxFit.cover,
              ),
              expandedHeight: 240,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          text: '主页',
                        ),
                        Tab(
                          text: '主页',
                        ),
                        Tab(
                          text: '主页',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: _tab,
      ),
    );
  }

  Widget get _tab => TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(children: _child),
            padding: EdgeInsets.symmetric(vertical: 10),
            physics: NeverScrollableScrollPhysics(),
          ),
          SingleChildScrollView(
            child: Column(children: _child),
            padding: EdgeInsets.symmetric(vertical: 10),
            physics: NeverScrollableScrollPhysics(),
          ),
          SingleChildScrollView(child: Column(children: _child)),
        ],
      );

  List<Widget> get _child => List.generate(
        20,
        (index) {
          return Container(
            height: 100,
            color: Colors.red,
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
          );
        },
      );
}
