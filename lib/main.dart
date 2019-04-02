import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/DiscoveryPage.dart';
import 'pages/MyInfoPage.dart';
import 'pages/NewsListPage.dart';
import 'pages/TweetsListPage.dart';
import './widgets/MyDrawer.dart';
void main() {
  runApp(new MyOSCClient());
}

class MyOSCClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyOSCClientState();
}

class MyOSCClientState extends State<MyOSCClient> {
//页面当前选中Tab的索引
  int _tabIndex = 0;

//页面body部分组件
  var _body;

  //页面底部的图标数组
  var tabImages;

  final tabTextStyleNormal = new TextStyle(color: const Color(0xff969696));
  final tabTextStyleSelected = new TextStyle(color: const Color(0xff63ca6c));

  //页面顶部的大标题
  var appBarTitles = ['资讯', '动态', '发现', '我的'];

  Image getTabImage(path)
  //数据初始化
  {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  void initData() {
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/ic_nav_news_normal.png'),
          getTabImage('images/ic_nav_news_actived.png')
        ],
        [
          getTabImage('images/ic_nav_tweet_normal.png'),
          getTabImage('images/ic_nav_tweet_actived.png')
        ],
        [
          getTabImage('images/ic_nav_discover_normal.png'),
          getTabImage('images/ic_nav_discover_actived.png')
        ],
        [
          getTabImage('images/ic_nav_my_normal.png'),
          getTabImage('images/ic_nav_my_pressed.png')
        ]
      ];
    }
    _body = new IndexedStack(
      children: <Widget>[
        new NewsListPage(),
        new TweetsListPage(),
        new DiscoveryPage(),
        new MyInfoPage()
      ],
      index: _tabIndex,
    );
  }
  //根据索引值确定TabItem的icon是选中的还是未选中的
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  //根据索引值确定返回顶部标题
  Text getTabTitle(int curIndex) {
    return new Text(
      appBarTitles[curIndex],
      style: getTabTextStyle(curIndex),
    );
  }

  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }
  @override
  Widget build(BuildContext context) {
    initData();
    return new MaterialApp(
        theme: new ThemeData(
          //设置页面的主颜色
          primaryColor: const Color(0xFF63CA6C),
        ),
        home: new Scaffold(
          appBar: new AppBar(
            //设置appbar 文本的样式
            title: new Text(
              appBarTitles[_tabIndex],
              style: new TextStyle(color: Colors.white),
            ),
            //设置appbar 图标的样式
            iconTheme: new IconThemeData(color: Colors.white),
          ),
          body: _body,
          bottomNavigationBar: new CupertinoTabBar(
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                  icon: getTabIcon(0), title: getTabTitle(0)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(1), title: getTabTitle(1)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(2), title: getTabTitle(2)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(3), title: getTabTitle(3)),
            ],
            currentIndex: _tabIndex,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
          ),
          drawer: new MyDrawer(),
        ));
  }
}
