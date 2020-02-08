import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/models.dart';
import '../actions/actions.dart';
import '../theme.dart';

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
    widget.store.dispatch(clientInfoAction(
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
    var accountAccessToken = widget.store.state.account.accessToken;
    print('access token: $accountAccessToken');
    if(accountAccessToken != ''){
      widget.store.dispatch(verifyAccessTokenAction(
        true,
        accountAccessToken,
        onAccountSucceed: (user){
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