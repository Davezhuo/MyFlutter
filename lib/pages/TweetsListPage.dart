import 'package:flutter/material.dart';

class TweetsListPage extends StatelessWidget {
  //热门动态列表数据
  List hotData = [];

  //普通动态数据
  List normalData = [];

  //动态作者文本样式
  TextStyle authorStyle;

  //动态时间样式
  TextStyle subtitleStyle;

//屏幕宽度
  double screenWidth;

  TweetsListPage() {
    authorStyle = new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
    subtitleStyle =
        new TextStyle(fontSize: 12.0, color: const Color(0xFFB5BDC0));
    //添加测试数据
    for (int i = 0; i < 20; i++) {
      Map<String, dynamic> map = new Map();
      // 动弹发布时间
      map['pubDate'] = '2018-7-30';
      // 动弹文字内容
      map['body'] =
          '早上七点十分起床，四十出门，花二十多分钟到公司，必须在八点半之前打卡；下午一点上班到六点，然后加班两个小时；八点左右离开公司，呼呼登自行车到健身房锻炼一个多小时。到家已经十点多，然后准备第二天的午饭，接着收拾厨房，然后洗澡，吹头发，等能坐下来吹头发时已经快十二点了。感觉很累。';
      // 动弹作者昵称
      map['author'] = '红薯';
      // 动弹评论数
      map['commentCount'] = 10;
      // 动弹作者头像URL
      map['portrait'] =
          'https://static.oschina.net/uploads/user/0/12_50.jpg?t=1421200584000';
      // 动弹中的图片，多张图片用英文逗号隔开
      map['imgSmall'] =
          'https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg';
      hotData.add(map);
      normalData.add(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    //获取屏幕的宽
    screenWidth = MediaQuery.of(context).size.width;
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new TabBar(tabs: <Widget>[
            new Tab(text: '动态列表'),
            new Tab(
              text: '热门动态',
            )
          ]),
          body:
              new TabBarView(children: [getNormalListView(), getHotListView()]),
        ));
  }

  //获取普通动态列表
  Widget getNormalListView() {
    return new ListView.builder(
      itemBuilder: renderNormalRow,
      itemCount: normalData.length * 2 - 1,
    );
  }

  //获取热门动态列表
  Widget getHotListView() {
    return new ListView.builder(
      itemBuilder: renderHotRow,
      itemCount: hotData.length * 2 - 1,
    );
  }

  Widget renderNormalRow(BuildContext context, int index) {
    if (index.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      index = index ~/ 2;
      return getRowWidget(normalData[index]);
    }
  }

  Widget renderHotRow(BuildContext context, int index) {
    if (index.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      index = index ~/ 2;
      return getRowWidget(hotData[index]);
    }
  }

  Widget getRowWidget(Map<String, dynamic> listItem) {
    //列表item的第一行，显示头像，昵称，评论数
    var authorRow = new Row(
      children: <Widget>[
        //用户头像
        new Container(
          width: 35.0,
          height: 35.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(color: Colors.white, width: 2.0),
              image: DecorationImage(
                  image: new NetworkImage(listItem['portrait']),
                  fit: BoxFit.cover)),
        ),
        //动态作者的昵称
        new Padding(
            padding: EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
            child: new Text(listItem['author'],
                style: new TextStyle(
                  fontSize: 16.0,
                ))),
        //动态评论数，显示在最右边
        new Expanded(
            child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Text(
              '${listItem['commentCount']}',
              style: subtitleStyle,
            ),
            new Image.asset(
              './images/ic_comment.png',
              width: 16.0,
              height: 16.0,
            )
          ],
        ))
      ],
    );

    var _contentBody = listItem['body'];
    //第二行显示动态内容
    var contentRow = new Row(
      children: <Widget>[new Expanded(child: new Text(_contentBody))],
    );
    var colums = <Widget>[
      new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 2.0),
          child: authorRow),
      new Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 0.0, 10.0, 0.0),
        child: contentRow,
      )
    ];
    //第三行显示九宫格图片
    //n表示图片的张数
    int getRow(int n) {
      int a = n % 3; //取余
      int b = n ~/ 2; //取整
      if (a != 0) {
        return b + 1;
      }
      return b;
    }

    String imgSmall = listItem['imgSmall'];
    if (imgSmall != null && imgSmall.length > 0) {
      //动态中有图片
      List<String> list = imgSmall.split(",");
      List<String> imgUrlList = new List<String>();
      for (String s in list) {
        if (s.startsWith("http")) {
          imgUrlList.add(s);
        } else {
          imgUrlList.add("https://static.oschina.net/uploads/space/" + s);
        }
      }
      List<Widget> imgList = [];
      List<List<Widget>> rows = [];
      num len = imgUrlList.length;
      //通过for循环，生成每一张图片组件
      for (var row = 0; row < getRow(len); row++) {
        List<Widget> rowArr = [];
        for (var col = 0; col < 3; col++) {
          //col为列数,固定3列
          num index = row * 3 + col;
          double cellWidth = (screenWidth - 100) / 3;
          if (index < len) {
            rowArr.add(new Padding(
                padding: EdgeInsets.all(2.0),
                child: new Image.network(
                  imgUrlList[index],
                  width: cellWidth,
                  height: cellWidth,
                )));
          }
        }
        rows.add(rowArr);
      }
      for (var row in rows) {
        imgList.add(new Row(
          children: row,
        ));
      }

      //显示动态发布时间
      var timeRow = new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Text(
            listItem['pubDate'],
            style: subtitleStyle,
          )
        ],
      );
      colums.add(new Padding(
        padding: EdgeInsets.fromLTRB(52.0, 5.0, 10.0, 0.0),
        child: new Column(children: imgList),
      ));
      colums.add(new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 6.0),
        child: timeRow,
      ));
    }
    return new InkWell(
        child: new Column(
          children: colums,
        ),
        onTap: () {});
  }
}
