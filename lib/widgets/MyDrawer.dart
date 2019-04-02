import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  //菜单文本前面的图标大小
  static const double IMAGE_ICON_WIDTH = 30.0;

  //菜单后面的箭头的图标大小
  static const double ARROW_ICON_WIDTH = 16.0;

  //菜单后面的箭头图标
  var rightArrowIcon = new Image.asset("images/ic_arrow_right.png",
      width: ARROW_ICON_WIDTH, height: ARROW_ICON_WIDTH);

//菜单文本
  List menuTiltes = ['发布动态', '动态小黑屋', '关于', '设置'];

  //菜单前面的图标
  List menuIcon = [
    'images/leftmenu/ic_fabu.png',
    'images/leftmenu/ic_xiaoheiwu.png',
    'images/leftmenu/ic_about.png',
    'images/leftmenu/ic_settings.png'
  ];

  //菜单文本的样式
  TextStyle menuTextStyle = new TextStyle(fontSize: 15.0);

//侧滑栏的宽度
  final double DRAWERWIDTH = 304.0;

  Widget rendenRow(BuildContext context,int index) {
    if (index == 0) {
      var img = new Image.asset(
        'images/cover_img.jpg',
        width: DRAWERWIDTH,
        height: DRAWERWIDTH,
      );
      return new Container(
        width: DRAWERWIDTH,
        height: DRAWERWIDTH,
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: img,
      );
    }
    //舍去之前的封面图
    index -= 1;
    //如果是奇数则渲染分割线
    if (index.isOdd) {
      return new Divider();
    }
    //偶数就除2取整,然后渲染item
    index = index ~/ 2;
    //菜单item组件

    Widget getIconImage(String path) {
      return new Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 0.0, 6.0, 0.0),
        child: new Image.asset(path,width: 28.0,height: 28.0,),
      );
    }
    var listItemContent = new Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      //row 组件构成item的一行
      child: new Row(
        children: <Widget>[
          //菜单item的图标
          getIconImage(menuIcon[index]),
          //菜单item的文本
          new Expanded(child: new Text(menuTiltes[index],style: menuTextStyle,)),
          rightArrowIcon,
        ],
      ),
    );

    return new InkWell(
      child: listItemContent,
      onTap: (){
        switch (index) {
          case 0:
            //发布动态

            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: const BoxConstraints.expand(width: 304.0),
      child: new Material(
        elevation: 16.0,
        child: new Container(
          decoration: BoxDecoration(color: const Color(0xffffffff)),
          child: new ListView.builder(
            itemBuilder: rendenRow,
            itemCount: menuTiltes.length * 2 + 1,
          ),
        ),
      ),
    );
  }
}
