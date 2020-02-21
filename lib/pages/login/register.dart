import 'package:flutter/material.dart';
import '../../config.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../components/common/app_navigate.dart';
import '../../components/common/app_bar.dart';
import '../../factory.dart';


class RegisterAccount extends StatelessWidget {
  RegisterAccount({Key key}) : super(key: key);

  final _logger = MaFactory().getLogger('Maservice');

  @override
  Widget build(BuildContext context) {
    final _flutterWebviewPlugin = new FlutterWebviewPlugin();
    _flutterWebviewPlugin.onUrlChanged.listen((String url){
      _logger.fine('url changed to: $url');
      if (url.contains("/auth/setup")) {
        _logger.fine('dialog...');

        AppNavigate.pop(context);
        _showRegisterSuccessedDiadlog(context);
      }
    });

    return WebviewScaffold(
      url: MaApi.Register,
      appBar: createAppBar(context, '注册'),
      withZoom: true,
      withLocalStorage: true,
      clearCookies: true,
    );
  }
}


Future<void> _showRegisterSuccessedDiadlog(BuildContext context){
  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            '请完成邮箱验证',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Text("欢迎加入 「Megacademia 学术万象」！请前往您所使用的注册邮箱查收确认邮件，并根据指引完成账号确认！"),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 60, 10, 10),
                  child: Image(image: AssetImage('assets/images/ma_welcome.png'),),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("确定"),
              onPressed: () => Navigator.of(context).pop(true), //关闭对话框
            ),
          ],
        );
  });
}
