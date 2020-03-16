import 'package:flutter/material.dart';
import 'package:megacademia/actions/account.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:megacademia/components/common/app_navigate.dart';
import 'package:redux/redux.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../../components/common/app_bar.dart';
import '../../components/common/failed_snack_bar.dart';
import '../../utils/regex_util.dart';

class EditUserInfoPage extends StatelessWidget {

  EditUserInfoPage({
    Key key,
  }) : super(key: key);

//  @override
//  _BodyState createState() => _BodyState();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: store.state.account.user,
      ),
      builder: (context, vm) => _Body(
        vm: vm,
        store: StoreProvider.of<AppState>(context)
      )
    );
  }
}

class _ViewModel {
  UserEntity user;

  _ViewModel({
    @required this.user,
  });
}

class _Body extends StatefulWidget{
  final Store<AppState> store;
  final _ViewModel vm;

  _Body({
    Key key,
    @required this.store,
    @required this.vm,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}


class _BodyState extends State<_Body> {
  final _userDisplayNameFocus = FocusNode();
  final _noteFocus = FocusNode();
  TextEditingController _userDisplayNameEditingController = TextEditingController();
  TextEditingController _noteEditingController = TextEditingController();

  _BodyState();

  @override
  void initState() {
    super.initState();
    this._userDisplayNameEditingController.text = widget.vm.user.displayName;
    this._noteEditingController.text = noteTransformStr(widget.vm.user.note);
  }

  void _submit() {
    StoreProvider.of<AppState>(context).dispatch(accountEditAction(
      displayName: _userDisplayNameEditingController.text,
      note: _noteEditingController.text,
      onSucceed: (UserEntity user) {
        AppNavigate.pop(context, param: null);
      },
      onFailed: (NoticeEntity notice) {
        createFailedSnackBar(context, notice: notice);
      },
    ));
  }

  Widget _CompleteButton(){
    return Container(
      padding: EdgeInsets.all(15.0),
      width: 90.0,
      child: FlatButton(
        child: Text('完成',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),),
        color: MaTheme.maYellows,
        onPressed: _submit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, '编辑个人资料', actions:[_CompleteButton()]),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: '昵称',
                labelStyle: TextStyle(
                  color: MaTheme.maYellows,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: MaTheme.maYellows,
                  ),
                ),
              ),
              maxLength: 15,
              maxLengthEnforced: true,
              controller: _userDisplayNameEditingController,
              focusNode: _userDisplayNameFocus,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                _userDisplayNameFocus.unfocus();
                FocusScope.of(context).requestFocus(_noteFocus);
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '研究兴趣领域',
                labelStyle: TextStyle(
                  color: MaTheme.maYellows,
                  fontSize: 12,
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: MaTheme.maYellows,
                  ),
                ),
              ),
              maxLength: 200,
              maxLines: 5,
              maxLengthEnforced: true,
              controller: _noteEditingController,
              focusNode: _noteFocus,
              textInputAction: TextInputAction.done,
//              onEditingComplete: _submit,
            ),
          ],
        ),
      ),
    );
  }
}