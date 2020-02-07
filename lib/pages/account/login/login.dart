import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megacademia/actions/account.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../theme.dart';
import '../../../config.dart';
import '../../../components/common/app_navigate.dart';
import '../../../components/common/app_bar.dart';
import '../../../components/common/failed_snack_bar.dart';
import 'authorize_user.dart';
import '../../../factory.dart';
import '../../../meta.dart';
import '../../../models/models.dart';
import 'register.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录 / 注册', style: TextStyle(color: Colors.white),),
        backgroundColor: MaTheme.maYellows,
      ),
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
  final TextEditingController _controller = new TextEditingController();
  bool _clickButton = false;
  final _logger = MaFactory().getLogger('Maservice');

  @override
  void initState() {
    super.initState();
  }

  Widget _showButtonLoading(BuildContext context, bool isLogin) {
    if (_clickButton) {
      return SpinKitThreeBounce(
        color: MaTheme.maYellows,
        size: 23,
      );
    }
    return Text(isLogin ? '使用Mastodon账号登录' : '注册',
        style:TextStyle(fontSize: 16, color:  MaTheme.maYellows));
  }

  void _webAuthorize() {
    AppNavigate.push(context, AuthorizeLogin(), callBack: (code) {
      widget.store.dispatch(accountAccessTokenAction(
        true,
        onSucceed:(){
          Navigator.pushReplacementNamed(context, '/tab');
          _logger.fine('access token: ${MaMeta.userAccessToken}');
        },
        onFailed: (notice){
          createFailedSnackBar(context, notice);
        },
        code: code
      ));
    });
  }

  void _register() {
    AppNavigate.push(context, RegisterAccount());
  }

  void _showAboutSheet(BuildContext context, bool which) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
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
                  child: Text(which ? MaGlobalValue.aboutMastodon : MaGlobalValue.aboutMegacademia),
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: MaTheme.maYellows,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            child: Column(
              children: <Widget>[
                Spacer(flex: 1),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.asset('assets/images/login.png'),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(child:
                      RaisedButton(
                        onPressed: () {
                          _webAuthorize();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: _showButtonLoading(context, true),
                        ),
                        color: Colors.white,
                      ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(child:
                      RaisedButton(
                        onPressed: () {
                          _register();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: _showButtonLoading(context, false),
                        ),
                        color: Colors.white,
                      ),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 6),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Spacer(flex: 2),
                      GestureDetector(
                        onTap: () {
                          _showAboutSheet(context, false);
                        },
                        child: Container(
                          child: Center(
                            child: Text('关于Megacademia',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                      GestureDetector(
                        onTap: () {
                          _showAboutSheet(context, true);
                        },
                        child: Container(
                          child: Center(
                            child: Text('关于Mastodon',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Text('${MaConfig.domain}',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
                Text('Version: ${MaGlobalValue.clientVersion}',
                    style: TextStyle(color: Colors.white, fontSize: 8)),
                Text(MaGlobalValue.copyRight,
                    style: TextStyle(color: Colors.white,fontSize: 6)),
                Spacer(flex: 1)
              ],
            ),
          ),
        )
    );
  }
}