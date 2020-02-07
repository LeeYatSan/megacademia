import 'package:flutter/material.dart';
import 'package:megacademia/components/common/app_navigate.dart';
import 'package:megacademia/icons.dart';
import 'package:megacademia/meta.dart';
import 'package:megacademia/pages/account/login/login.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../factory.dart';
import '../../config.dart';
import '../../theme.dart';
import '../../models/models.dart';
import '../../components/common/app_bar.dart';
import '../../components/common/failed_snack_bar.dart';
import '../../actions/actions.dart';
import '../tab.dart';

class SettingPage extends StatelessWidget {
  SettingPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, '设置'),
      body: _Body(store: StoreProvider.of<AppState>(context),),
    );
  }
}

class _Body extends StatefulWidget {
  final Store<AppState> store;

  _Body({
    @required this.store,
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body>{

  @override
  void initState() {
    super.initState();
  }

  Widget createMaListTile(BuildContext context, IconData icon, final title,
      {final subTitle, Widget trailing, Function onTap}){
    return ListTile(
        leading: Icon(icon, color: MaTheme.maYellows, size: 30,),
        title: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
        subtitle: Text(subTitle, style: TextStyle(fontSize: 10),),
        trailing: trailing,
        onTap: onTap,
    );
  }

  void _logout() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    print(MaMeta.user.toJson().toString());
//    prefs.setString(MaGlobalValue.userInfo, MaMeta.user.toJson().toString());
    Navigator.pushReplacementNamed(TabPage.globalKey.currentContext, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 30,
            ),
            createMaListTile(context, Icons.lock, '锁定账户',
              subTitle: '启用后其他用户需要通过你的确认才可关注你',
              trailing: Switch(
                value: MaMeta.user.locked,
                activeColor: MaTheme.maYellows,
                onChanged: (_changed){
                  print('Locked: $_changed');
                  this.setState(() {
                    MaMeta.user.locked = _changed;
                    widget.store.dispatch(accountEditAction(
                      MaMeta.userAccessToken,
                      locked: _changed,
                      onSucceed: (user){
                        MaMeta.user = user;
                      },
                      onFailed: (notice){
                        MaMeta.user.locked = !_changed;
                        createFailedSnackBar(context, notice);
                      }
                    ));
                  });
                },
              ),
            ),
            createMaListTile(context, Icons.vpn_key, '密码与登录安全',
              subTitle: '管理账户密码、查看登录记录',
              onTap: (){
                AppNavigate.push(
                    context,
                    WebviewScaffold(
                      url: MaApi.AuthEdit,
                      appBar: createAppBar(context, '密码与登录安全'),
                      withZoom: true,
                      withLocalStorage: true,
                      clearCookies: true,
                    )
                );
              },
            ),
            createMaListTile(context, Icons.more_horiz, '更多设置',
              subTitle: '进入Mastodon WEB版后台设置更多特性',
              onTap: (){
                AppNavigate.push(
                    context,
                    WebviewScaffold(
                      url: MaApi.MoreSetting,
                      appBar: createAppBar(context, '更多设置'),
                      withZoom: true,
                      withLocalStorage: true,
                      clearCookies: true,
                    )
                );
              },
            ),
            createMaListTile(context, Icons.info_outline, '软件信息',
              subTitle: '关于Megacademia',
              onTap: (){
              return showBottomSheet(
                  context: context,
                  builder: (BuildContext context){
                    return Container(
                      height: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            width: 50,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(MaGlobalValue.about),
                          )
                        ],
                      ),
                    );
                  });
              },
            ),
            Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Container(
//                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        margin: EdgeInsets.only(left: 60.0, right: 60.0),
                        child: Text('退出登录', style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w500, letterSpacing: 5),),
                      ),
                      color: Colors.redAccent,
                      onPressed: (){
                        _logout();
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadiusDirectional.circular(20),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}