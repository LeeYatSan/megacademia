import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/common/failed_snack_bar.dart';
import 'user_tile.dart';


class UserList extends StatefulWidget {
  final int type; // 0->usersFollowing 1->followers 2->muteUsers 3->blockedUsers
  UserEntity user;

  UserList({
    Key key,
    @required this.type,
    @required this.user,
  }) : super(key: key);

  @override
  _UserListState createState() => _UserListState(type, user);
}

class _UserListState extends State<UserList> {
  static final _bodyKey = GlobalKey<_BodyState>();
  final _type;
  UserEntity _user;

  _UserListState(this._type, this._user);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: _user,
        targetList: _getTargetList(store.state),
      ),
      builder: (context, vm) => Scaffold(
        body: _Body(
          key: _bodyKey,
          store: StoreProvider.of<AppState>(context),
          vm: vm,
          type: _type,
        ),
      ),
    );
  }

  List<UserEntity> _getTargetList(AppState state){
    List<UserEntity> res;
    switch(_type){
      case 0:{
        res = state.user.followingUsers;
      }break;
      case 1:{
        res = state.user.followers;
      }break;
      case 2:{
        res = state.user.muteUsers;
      }break;
      case 3:{
        res = state.user.blockedUsers;
      }break;
    }
    return res;
  }
}

class _ViewModel {
  final UserEntity user;
  final List<UserEntity> targetList;

  _ViewModel({
    @required this.user,
    @required this.targetList,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;
  final type;

  _Body({
    Key key,
    @required this.store,
    @required this.vm,
    @required this.type,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState(type);
}

class _BodyState extends State<_Body> {
  final _scrollController = ScrollController();
  var _isLoading = false;
  final _type;

  _BodyState(this._type);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    _loadUsers(recent: true, more: false, type: _type);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void _loadUsers({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    int type = 0,
    Completer<Null> completer,
  }) {
    if (_isLoading) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoading = true;
      });
    }

    int offset;
    if (more) {
      offset = widget.vm.targetList.length;
    }

    switch(_type){
      case 0:{
        _loadFolloweringUsers(widget.vm.user.id, offset, refresh, completer);
      }break;
      case 1:{
        _loadFollowers(widget.vm.user.id, offset, refresh, completer);
      }break;
      case 2:{
        _loadMuteUsers(widget.vm.user.id, offset, refresh, completer);
      }break;
      case 3:{
        _loadBlockedUsers(widget.vm.user.id, offset, refresh, completer);
      }break;
    }
  }

  Future<Null> _refresh(int type) {
    final completer = Completer<Null>();
    _loadUsers(
      more: false,
      refresh: true,
      type: type,
      completer: completer,
    );
    return completer.future;
  }

  void _loadFolloweringUsers(String id, int offset,
      bool refresh, Completer<Null> completer){

  }

  void _loadFollowers(String id, int offset,
      bool refresh, Completer<Null> completer){

  }

  void _loadMuteUsers(String id, int offset,
      bool refresh, Completer<Null> completer){
    widget.store.dispatch(getMuteUsersListAction(
      userId: widget.vm.user.id,
      offset: offset,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoading = false;
          });
        }
        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoading = false;
          });
        }

        completer?.complete();

        createFailedSnackBar(context, notice: notice);
      },
    ));
  }

  void _loadBlockedUsers(String id, int offset,
      bool refresh, Completer<Null> completer){
    widget.store.dispatch(getBlockUsersListAction(
      userId: widget.vm.user.id,
      offset: offset,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoading = false;
          });
        }
        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoading = false;
          });
        }

        completer?.complete();

        createFailedSnackBar(context, notice: notice);
      },
    ));
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: (){return _refresh(_type);},
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(height: 1),
            itemCount: widget.vm.targetList.length,
            itemBuilder: (context, index) => UserTile(
              key: Key(widget.vm.targetList[index].id.toString()),
              user: widget.vm.targetList[index],
              type: _type,
              store: widget.store,
            ),
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}

