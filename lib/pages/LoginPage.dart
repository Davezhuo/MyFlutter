import 'dart:async';
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import '../util/DataUtils.dart';
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    LoginPageState createState = new LoginPageState();
    return createState;
  }
}

class LoginPageState extends State<LoginPage> {
  int count = 0;
  final MAX_COUNT = 5;
  bool loading = true;
  bool isLoadingCallbackPage = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {}

  parseResult() {
    flutterWebViewPlugin.evalJavascript("get();").then((result) {
      if (result != null && result.length > 0) {
        var map = json.decode(result);
        if (map is String) {
          map = json.decode(map);
        }
        if(map!=null) {
          DataUtils.saveLoginInfo(map);
          Navigator.pop(context,"refresh");

        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // 监听WebView的加载事件，该监听器已不起作用，不回调
    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      // state.type是一个枚举类型，取值有：WebViewState.shouldStart, WebViewState.startLoad, WebViewState.finishLoad
      switch (state.type) {
        case WebViewState.shouldStart:
          // 准备加载
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad:
          // 开始加载
          break;
        case WebViewState.finishLoad:
          // 加载完成
          setState(() {
            loading = false;
          });
          if (isLoadingCallbackPage) {
            // 当前是回调页面，则调用js方法获取数据
            parseResult();
          }
          break;
      }
    });
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((url) {
      // 登录成功会跳转到自定义的回调页面，该页面地址为http://yubo725.top/osc/osc.php?code=xxx
      // 该页面会接收code，然后根据code换取AccessToken，并将获取到的token及其他信息，通过js的get()方法返回
      if (url != null && url.length > 0 && url.contains("osc/osc.php?code=")) {
        isLoadingCallbackPage = true;
      }
    });
  }
}
