import 'package:flutter/material.dart';
import 'package:megacademia/config.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../actions/actions.dart';
import '../theme.dart';
import '../meta.dart';
import '../factory.dart';

class BootstrapPage extends StatelessWidget {
  BootstrapPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Body(
        store: StoreProvider.of<AppState>(context),
      ),
    );
  }
}

class _Body extends StatefulWidget{
  final Store<AppState> store;

  _Body({
    Key key,
    @required this.store,
  }) : super(key : key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body>{
  var _isFailed = false;

  @override
  void initState(){
    super.initState();

    _bootstrap();
  }

  void _login(){
    widget.store.dispatch(accountInfoAction(
        onSucceed: (clientId){
          Navigator.of(context).pushReplacementNamed('/login');
        },
        onFailed: (notice){
          setState(() {
            _isFailed = true;
          });
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          ));
        }
    ));
  }

  void _bootstrap() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.clear(); // 清空存储数据
    var accountAccessToken = prefs.get(MaGlobalValue.accessToken);
    if(accountAccessToken != null){
      widget.store.dispatch(verifyAccessTokenAction(
        true,
        accountAccessToken,
        onAccountSucceed: (user){
          MaMeta.user = user;
          MaMeta.userAccessToken = accountAccessToken;
          MaMeta.clientSecret = prefs.get(MaGlobalValue.clientSecret);
          MaMeta.userAccessToken = prefs.get(MaGlobalValue.accessToken);
          Navigator.of(context).pushReplacementNamed('/tab');
        },
        onFailed: (notice){
          _login();
        },
      ));
    }
    else{
      _login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 5),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: Image(
              image: AssetImage('assets/images/ma_logo_with_bottom_word.png'),
            ),
          ),
          Spacer(),
          _isFailed ? Column(
            children: <Widget>[
              Text(
                '网络请求出错',
                style: TextStyle(color: Colors.grey[600]),
              ),
              FlatButton(
                onPressed: (){
                  setState(() {
                    _isFailed = false;
                  });
                  _bootstrap();
                },
                child: Text(
                  '再试一次',
                  style: TextStyle(color: MaTheme.maYellows),
                ),
              )
            ],
          )
              : Text('网络请求中...'),
          Spacer(flex: 5),
        ],
      ),
    );
  }
}