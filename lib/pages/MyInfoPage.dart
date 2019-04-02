import 'package:flutter/material.dart';
import 'package:zhuo/pages/LoginPage.dart';
import '../util/DataUtils.dart';
class MyInfoPage extends StatelessWidget {
  static const double ARROW_ICON_WIDTH = 16.0;
  static const double ICON_ICON_WIDTH = 30.0;
  var titles = ['我的消息', '阅读记录', '我的博客', '我的问答', '我的活动', '我的团队', '我的邀请'];
  final icons = [
    'images/ic_my_message.png',
    'images/ic_my_blog.png',
    'images/ic_my_blog.png',
    'images/ic_my_question.png',
    'images/ic_discover_pos.png',
    'images/ic_my_team.png',
    'images/ic_my_recommend.png'
  ];
  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var arrowImage = new Image.asset(
    "images/ic_arrow_right.png",
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  var loginTextStyle = new TextStyle(fontSize: 18.0, color: Colors.white);
  _showUserInfoDetail() {}

  _login() async{


  }
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: renderRow,
      itemCount: titles.length * 2 + 1,
    );
  }

  Widget renderRow(BuildContext context, int index) {
    if (index == 0) {
      var avatarContainer =  new Container(
        height: 200.0,
        decoration: BoxDecoration(color: Color(0xff63ca6c)),
        child: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            new Image.asset(
              "images/ic_avatar_default.png",
              width: 64.0,
              height: 64.0,
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
              child: new Text(
                "点击头像登录",
                style: loginTextStyle,
              ),
            )
          ]),
        ),
      );
      return new GestureDetector(child: avatarContainer,onTap: (){
        DataUtils.isLogin().then((isLogin){
          if(isLogin) {
            // 已登录，显示用户详细信息
            _showUserInfoDetail();
          }else{
            // 未登录，跳转到登录页面
            _login();
          }
        });
      },);
    }
    index -= 1;
    if (index.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      index = index ~/ 2;
      var item = new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: new Row(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: new Image.asset(
                icons[index],
                width: ICON_ICON_WIDTH,
                height: ICON_ICON_WIDTH,
              ),
            ),
            new Expanded(
                child: new Text(
              titles[index],
              style: titleTextStyle,
            )),
            arrowImage
          ],
        ),
      );
      return new InkWell(
        child: item,
        onTap: () {},
      );
    }
  }
}
