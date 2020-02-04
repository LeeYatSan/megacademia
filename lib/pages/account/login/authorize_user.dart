import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../config.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../../utils/app_navigate.dart';


class AuthorizeLogin extends StatelessWidget {
  AuthorizeLogin({Key key}) : super(key: key);

  String url = '${MaConfig.maApiBaseUrl}/oauth/authorize?scope=read%20write%20follow%20push&response_type=code&redirect_uri=${MaGlobalValue.redirectUrl}&client_id=${MaMeta.clientId}';

  @override
  Widget build(BuildContext context) {
    final _flutterWebviewPlugin = new FlutterWebviewPlugin();
    _flutterWebviewPlugin.onUrlChanged.listen((String url) {
      List<String> urlList = url.split("?");
      if (urlList[0].contains("/native") && urlList[1].length != 0) {
        List<String> codeList = url.split("=");
        AppNavigate.pop(context, param: codeList[1]);
      }
    });

    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        title: Text('Mastodon授权登录', style: TextStyle(color: Colors.white)),
        backgroundColor: MaTheme.maYellows,
      ),
      withZoom: true,
      withLocalStorage: true,
      clearCookies: true,
      clearCache: true,
    );

//    return Scaffold(
//      body: WebviewScaffold(
//        url: url,
//        appBar: AppBar(
//          title: Text('Mastodon授权登录', style: TextStyle(color: Colors.white)),
//          backgroundColor: MaTheme.maYellows,
//        ),
//        withZoom: true,
//        withLocalStorage: true,
//        clearCookies: true,
//        clearCache: true,
//      ),
//      resizeToAvoidBottomPadding: false,
//    );
  }
}