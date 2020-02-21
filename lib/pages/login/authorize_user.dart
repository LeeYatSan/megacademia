import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../theme.dart';
import '../../icons.dart';
import '../../config.dart';

class AuthorizeLogin extends StatelessWidget {
  AuthorizeLogin({Key key}) : super(key: key);

  String url = '${MaConfig.maApiBaseUrl}/oauth/authorize?scope=read%20write%20follow%20push&response_type=code&redirect_uri=${MaGlobalValue.redirectUrl}&client_id=';

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

    return StoreConnector<AppState, String>(
      converter: (store) => store.state.clientId,
      builder: (context, clientId) => WebviewScaffold(
        url: '$url$clientId',
        appBar: AppBar(
          title: Text('Mastodon授权登录', style: TextStyle(color: Colors.white)),
          backgroundColor: MaTheme.maYellows,
          leading: IconButton(
            icon: Icon(MaIcon.back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        withZoom: true,
        withLocalStorage: true,
        clearCookies: true,
//      clearCache: true,
      ),
    );
  }
}