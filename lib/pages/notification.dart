import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../theme.dart';

class NotificationPage extends StatefulWidget {

  NotificationPage({
    Key key,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _tabs = ['通知', '关注请求'];
  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        followingStatus: (store.state.status.followingStatus ?? [])
            .map<StatusEntity>((v) => store.state.status.statuses[v.toString()])
            .toList(),
        allStatus: store.state.status.statuses.values.toList().reversed.toList(),
      ),
      builder: (context, vm) => Scaffold(
        body: DefaultTabController(
          length: _tabs.length,
          child: _Body(
            key: _bodyKey,
            store: StoreProvider.of<AppState>(context),
            vm: vm,
            tabs: _tabs,
          ),
        ),
        bottomNavigationBar: MaTabBar(tabIndex: 2),
      ),
    );
  }
}

class _ViewModel {
  final List<StatusEntity> followingStatus;
  final List<StatusEntity> allStatus;

  _ViewModel({
    @required this.followingStatus,
    @required this.allStatus,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;
  final List<String> tabs;

  _Body({
    Key key,
    @required this.store,
    @required this.vm,
    @required this.tabs,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final scrollController = ScrollController();
//
//  @override
//  void initState() {
//    super.initState();
//
//    scrollController.addListener(_scrollListener);
//  }
//
//  @override
//  void dispose() {
//    scrollController.removeListener(_scrollListener);
//    scrollController.dispose();
//
//    super.dispose();
//  }

//  void _scrollListener() {
//    final index = DefaultTabController.of(context).index;
//    if (scrollController.position.pixels ==
//        scrollController.position.maxScrollExtent) {
//      if (index == 0) {
////        _loadFollowingStatus();
//      } else if (index == 1) {
////        _loadNotifications();
//      }
//    }
//  }

  Widget _buildNotifications(BuildContext context) {
    return Scaffold(
      body: NotificationList(),
    );
  }

  Widget _buildFollowingRequest(BuildContext context) {
    return Scaffold(
      body: UserList(type: 4, user: widget.store.state.account.user),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: widget.tabs
          .map<Widget>((name) => SafeArea(
        top: false,
        bottom: false,
        child: Builder(
          builder: (context) {
            if (name == '通知') {
              return _buildNotifications(context);
            } else if (name == '关注请求') {
              return _buildFollowingRequest(context);
            } else {
              return null;
            }
          },
        ),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: ProfileSideBarButtom(),
          onPressed: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text('通知', style: TextStyle(fontWeight: FontWeight.w700),),
        bottom: TabBar(
          tabs: widget.tabs.map<Widget>((name) => Tab(text: name)).toList(),
          indicatorColor: MaTheme.maYellows,
          labelColor: MaTheme.maYellows,
          unselectedLabelColor: Colors.black,
          labelStyle: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
      ),
      drawer: MaDrawer(),
      body: _buildTabBarView(),
    );
  }
}
