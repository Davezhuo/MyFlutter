import 'package:flutter/material.dart';

class SlideView extends StatefulWidget {
  var data;

  //data表示轮播图中的数据
  SlideView(data) {
    this.data = data;
  }

  @override
  State createState() => new SlideViewState(data);
}

class SlideViewState extends State<SlideView>
    with SingleTickerProviderStateMixin {
  //TabController 为TabBarView组件的控制器
  TabController tabController;
  List sliedeData;

  SlideViewState(data) {
    sliedeData = data;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (sliedeData != null && sliedeData.length > 0) {
      for (var i = 0; i < sliedeData.length; i++) {
        var item = sliedeData[i];
        //图片url
        var imageUrl = item['imgUrl'];
        //资讯标题
        var title = item['title'];
        //资讯详情url
        var detailUrl = item['detailUrl'];
        items.add(new GestureDetector(
          onTap: () {
            //点击跳转到详情
          },
          child: new Stack(
            //Stack组件用于将资讯文本放在图片上面
            children: <Widget>[
              //加载图片
              new Image.network(imageUrl),
              new Container(
                width: MediaQuery.of(context).size.width,
                //背景为黑色，加入透明度
                color: const Color(0x50000000),
                //标题文本加入内边框
                child: new Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new Text(
                    title,
                    style: new TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              )
            ],
          ),
        ));
      }
    }
    return new TabBarView(
      controller: tabController,
        children: items,
    );
  }

  @override
  void initState() {
    super.initState();
    //初始化控制器
    tabController = new TabController(
        length: sliedeData == null ? 0 : sliedeData.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
