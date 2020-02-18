//import 'dart:async';
//import 'package:flutter/material.dart';
//import 'package:meta/meta.dart';
//import 'package:redux/redux.dart';
//import 'package:flutter_redux/flutter_redux.dart';
//
//import '../actions/actions.dart';
//import '../models/models.dart';
//import '../components/components.dart';
//
//class NotificationPage extends StatefulWidget {
//  NotificationPage({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  NotificationState createState() => NotificationState();
//}
//
//class NotificationState extends State<NotificationPage> with AutomaticKeepAliveClientMixin {
//  bool _isLoading = false;
//  final scrollController = ScrollController();
//  @override
//  bool get wantKeepAlive => true;
//
//  @override
//  void initState() {
//    super.initState();
//    scrollController.addListener(_scrollListener);
//    _loadNotification();
//  }
//
//  @override
//  void dispose() {
//    scrollController.removeListener(_scrollListener);
//    scrollController.dispose();
//
//    super.dispose();
//  }
//
//  void _scrollListener() {
//    if (scrollController.position.pixels ==
//        scrollController.position.maxScrollExtent) {
//      _loadNotification();
//    }
//  }
//
//  void _loadNotification({
//    bool refresh = false,
//    Completer<Null> completer,
//  }) {
//    final store = StoreProvider.of<AppState>(context);
//
//    if (_isLoading) {
//      completer?.complete();
//      return;
//    }
//
//    if (!refresh) {
//      setState(() {
//        _isLoading = true;
//      });
//    }
//
//    store.dispatch(getNotificationsAction(
//      onSucceed: (){
//        if (!refresh) {
//          setState(() {
//            _isLoading = false;
//          });
//        }
//        completer?.complete();
//      },
//      onFailed: (notice) {
//        if (!refresh) {
//          setState(() {
//            _isLoading = false;
//          });
//        }
//        completer?.complete();
//        createFailedSnackBar(context, notice: notice);
//      },
//    ));
//  }
//
//  Future<Null> _refreshNotification() {
//    final completer = Completer<Null>();
//    _loadNotification(
//      refresh: true,
//      completer: completer,
//    );
//    return completer.future;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: Text('通知', style: TextStyle(fontWeight: FontWeight.w700),),
//          centerTitle: true,
//          backgroundColor: Colors.white,
//        ),
//        body: StoreConnector<AppState, _ViewModel>(
//          converter: (store) => _ViewModel(
//            notifications: store.state.notification.notifications,
//            requestFollowAccounts: store.state.notification.requestFollowAccounts,
//          ),
//          builder: (context, vm) => SafeArea(
//            child: Stack(
//              children: <Widget>[
//                RefreshIndicator(
//                  onRefresh: _refreshNotification,
//                  child: CustomScrollView(
//                    key: PageStorageKey<String>('likeStatus'),
//                    physics: const AlwaysScrollableScrollPhysics(),
//                    slivers: <Widget>[
//                      SliverList(
//                        delegate: SliverChildBuilderDelegate(
//                              (context, index) => NotificationItem(
//                                key: Key(vm.notifications.length != 0 ?
//                                  vm.notifications[index].id :
//                                  vm.requestFollowAccounts[index-vm.notifications.length].id),
//                                user: vm.notifications.length != 0 ?
//                                  vm.notifications[index].account :
//                                  vm.requestFollowAccounts[index-vm.notifications.length],
//                                notification: index < vm.notifications.length ?
//                                  vm.notifications[index] : null,
//                          ),
//                          childCount: vm.notifications.length + vm.requestFollowAccounts.length,
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                Visibility(
//                  visible: _isLoading,
//                  child: Center(
//                    child: CircularProgressIndicator(),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
//    );
//  }
//}
//
//class _ViewModel {
//  final List<NotificationEntity> notifications;
//  final List<UserEntity> requestFollowAccounts;
//
//  _ViewModel({
//    @required this.notifications,
//    @required this.requestFollowAccounts,
//  });
//}

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
//  var _isLoadingFollowingStatus = false;
//  var _isLoadingAllStatus = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);

//    _loadFollowingStatus(recent: true, more: false);
//    _loadNotifications(recent: true, more: false);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    final index = DefaultTabController.of(context).index;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (index == 0) {
//        _loadFollowingStatus();
      } else if (index == 1) {
//        _loadNotifications();
      }
    }
  }

//  void _loadFollowingStatus({
//    bool recent = false,
//    bool more = true,
//    bool refresh = false,
//    Completer<Null> completer,
//  }) {
//    if (_isLoadingFollowingStatus) {
//      completer?.complete();
//      return;
//    }
//
//    if (!refresh) {
//      setState(() {
//        _isLoadingFollowingStatus = true;
//      });
//    }
//
//    String beforeId;
//    if (more && widget.vm.followingStatus.isNotEmpty) {
//      beforeId = widget.vm.followingStatus.last.id;
//    }
//    String afterId;
//    if (recent && widget.vm.followingStatus.isNotEmpty) {
//      afterId = widget.vm.followingStatus.first.id;
//    }
//    widget.store.dispatch(getFollowingStatusAction(
//      beforeId: beforeId,
//      afterId: afterId,
//      refresh: refresh,
//      onSucceed: (statuses) {
//        if (!refresh) {
//          setState(() {
//            _isLoadingFollowingStatus = false;
//          });
//        }
//
//        completer?.complete();
//      },
//      onFailed: (notice) {
//        if (!refresh) {
//          setState(() {
//            _isLoadingFollowingStatus = false;
//          });
//        }
//
//        completer?.complete();
//
//        createFailedSnackBar(context, notice: notice);
//      },
//    ));
//  }

//  void _loadNotifications({
//    bool recent = false,
//    bool more = true,
//    bool refresh = false,
//    Completer<Null> completer,
//  }) {
//    if (_isLoadingAllStatus) {
//      completer?.complete();
//      return;
//    }
//
//    if (!refresh) {
//      setState(() {
//        _isLoadingAllStatus = true;
//      });
//    }
//
//    String beforeId;
//    if (more && widget.vm.allStatus.isNotEmpty) {
//      beforeId = widget.vm.allStatus.last.id;
//    }
//    String afterId;
//    if (recent && widget.vm.allStatus.isNotEmpty) {
//      afterId = widget.vm.allStatus.first.id;
//    }
//    widget.store.dispatch(getPublicStatusAction(
//      limit: 10,
//      beforeId: beforeId,
//      afterId: afterId,
//      refresh: refresh,
//      onSucceed: (posts) {
//        if (!refresh) {
//          setState(() {
//            _isLoadingAllStatus = false;
//          });
//        }
//
//        completer?.complete();
//      },
//      onFailed: (notice) {
//        if (!refresh) {
//          setState(() {
//            _isLoadingAllStatus = false;
//          });
//        }
//
//        completer?.complete();
//
//        Scaffold.of(context).showSnackBar(SnackBar(
//          content: Text(notice.message),
//          duration: notice.duration,
//        ));
//      },
//    ));
//  }

//  Future<Null> _refreshFollowingStatuses() {
//    final completer = Completer<Null>();
//    _loadFollowingStatus(
//      more: false,
//      refresh: true,
//      completer: completer,
//    );
//    return completer.future;
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
