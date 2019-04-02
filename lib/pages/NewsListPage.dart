import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/SlideView.dart';
import '../util/NetUtils.dart';
import '../api/Api.dart';
import 'dart:convert';
import '../constant/Constants.dart';

//资讯列表页面
class NewsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewsListPageState();
  }
}

class NewsListPageState extends State {
  ScrollController _controller = new ScrollController();

  //轮播图的数据
  var slideData = [];

  //列表的数据（轮播图数据和列表数据分开，但是实际上轮播图和列表中的item同属于ListView的item）
  var listData ;

  var curPage = 1;
  var listTotalSize = 0;

  //列表中资讯标题的样式
  TextStyle textStyle = new TextStyle(
    fontSize: 15.0,
  );

  //时间文本的样式
  TextStyle subTitleStyle =
      new TextStyle(fontSize: 12.0, color: const Color(0xFFB5BDC0));

  @override
  void initState() {
    super.initState();
    getNewList(false);
  }

  NewsListPageState() {
    _controller.addListener(() {
      // 表示列表的最大滚动距离
      var maxScroll = _controller.position.maxScrollExtent;
      // 表示当前列表已向下滚动的距离
      var pixels = _controller.position.pixels;
// 如果两个值相等，表示滚动到底，并且如果列表没有加载完所有数据
      if (maxScroll == pixels && listData.length < listTotalSize) {
        print("load more ... ");
        curPage++;
        getNewList(true);
      }
    });
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getNewList(false);
    return null;
  }

  getNewList(bool isLoadMore) {
    String url = Api.NEWS_LIST;
    url += "?pageIndex=$curPage&pageSize=10";
    print("newsListUrl: $url");
    NetUtils.get(url).then((data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['code'] == 0) {
          var msg = map['msg'];
          listTotalSize = msg['news']['total'];
          var _listData = msg['news']['data'];
          var _slideData = msg['slide'];
          setState(() {
            if (!isLoadMore) {
              listData = _listData;
              slideData = _slideData;
            } else {
              List list1 = new List();
              list1.addAll(listData);
              list1.addAll(_listData);
              if (list1.length >= listTotalSize) {
                list1.add(Constants.END_LINE_TAG);
              }
              listData = list1;
              slideData = _slideData;
            }
          });
        }
      }
    });
  }

  Widget renderRow(BuildContext context, int index) {
    //i==0时渲染轮播图
    if (index == 0) {
      return new Container(
        height: 180.0,
        child: new SlideView(slideData),
      );
    }
    index -= 1;
    if (index.isOdd) {
      //奇数时显示分割线
      return new Divider(
        height: 1.0,
      );
    }
    index = index ~/ 2;
    //得到列表item的数据
    var itemData = listData[index];
    var titleRow = new Row(
      children: <Widget>[
        //标题充满一整行时所以用expand包裹
        new Expanded(
            child: new Text(
          itemData['title'],
          style: textStyle,
        ))
      ],
    );
    //时间这一行包含了作者的头像，时间，评论数
    var timeRow = new Row(
      children: <Widget>[
        //这是作者头像，使用了圆形头像
        new Container(
          width: 20.0,
          height: 20.0,
          decoration: new BoxDecoration(
              //通过指定shape属性设置图片为圆形
              shape: BoxShape.circle,
              color: const Color(0xFFECECEC),
              image: new DecorationImage(
                  image: new NetworkImage(itemData['authorImg']),
                  fit: BoxFit.cover),
              border:
                  new Border.all(width: 2.0, color: const Color(0xFFECECEC))),
        ),
        //这是时间文本
        new Padding(
          padding: const EdgeInsets.all(0.0),
          child: new Text(
            itemData['timeStr'],
            style: subTitleStyle,
          ),
        ),
        //这是评论数
        new Expanded(
            child: new Row(
          //为了让评论数显示在最右侧，所以需要在外面的Expand和这里的MainAxisAliment.end
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Text(
              "${itemData['commCount']}",
              style: subTitleStyle,
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
    var thumbImgUrl = itemData['thumb'];
    var thumbImg = new Container(
      margin: const EdgeInsets.all(10.0),
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
          color: const Color(0xFFECECEC),
          shape: BoxShape.circle,
          image: new DecorationImage(
//              image: new NetworkImage(thumbImgUrl), fit: BoxFit.cover)),
              image: new ExactAssetImage('./images/ic_img_default.jpg'),
              fit: BoxFit.cover),
          border: new Border.all(color: Color(0xFFECECEC), width: 2.0)),
    );
    //如果之前的thunImgUrl不为空，就把之前thumbImg默认的图片替换成网络图片
    if (thumbImgUrl != null && thumbImgUrl.length > 1) {
      thumbImg = new Container(
        margin: const EdgeInsets.all(10.0),
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
            color: const Color(0xFFECECEC),
            shape: BoxShape.circle,
            image: new DecorationImage(
                image: new NetworkImage(thumbImgUrl), fit: BoxFit.cover),
            border: new Border.all(color: Color(0xFFECECEC), width: 2.0)),
      );
    }
    //这里的row代表了一个listItem的一行
    var row = new Row(
      children: <Widget>[
        //左边是标题，时间，评论数
        new Expanded(
            flex: 1,
            child: new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Column(
                  children: <Widget>[
                    titleRow,
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: timeRow,
                    )
                  ],
                ))),
        //右边是资讯图
        new Padding(
          padding: const EdgeInsets.all(6.0),
          child: new Container(
            width: 100.0,
            height: 100.0,
            color: const Color(0xFFECECEC),
            child: new Center(
              child: thumbImg,
            ),
          ),
        )
      ],
    );
    return new InkWell(child: row, onTap: () {});
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return new Center(
        //CircularProgressIndicator 是一个圆形的loading进度条
        child: CircularProgressIndicator(),
      );
    } else {
      //有数据，显示ListView
      Widget listView = new ListView.builder(
        itemBuilder: renderRow,
        itemCount: listData.length * 2 + 1,
        controller: _controller,
      );
      //RefreshIndicator为ListView 增加了下拉刷新能力，onfresh参数传入一个方法，在下拉刷新时调用
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }
}
