import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../actions/actions.dart';
import '../theme.dart';
import '../utils/number.dart';
//
//class HomePage extends StatelessWidget {
//  static final _bodyKey = GlobalKey<_BodyState>();
//  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//  final _tabs = ['关注', '广场'];
//
//  HomePage({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return StoreConnector<AppState, _ViewModel>(
//      converter: (store) => _ViewModel(
//        postsFollowing: store.state.post.postsFollowing
//            .map<PostEntity>((v) => store.state.post.posts[v.toString()])
//            .toList(),
//      ),
//      builder: (context, vm) => Scaffold(
//        key: _scaffoldKey,
//        appBar: AppBar(
//          iconTheme: IconThemeData(color: Colors.white),
//          leading: IconButton(
//            icon: ProfileSideBarButtom(),
//            onPressed: (){
//              _scaffoldKey.currentState.openDrawer();
//            },
//          ),
//          title: Text('首页', style: TextStyle(fontWeight: FontWeight.w700),),
//          bottom: TabBar(
//            tabs: _tabs.map<Widget>((name) => Tab(text: name)).toList(),
//          ),
//          backgroundColor: Colors.white,
//        ),
//        drawer: MaDrawer(),
//        body: _Body(
//          key: _bodyKey,
//          store: StoreProvider.of<AppState>(context),
//          vm: vm,
//        ),
//        bottomNavigationBar: MaTabBar(tabIndex: 0),
//      ),
//    );
//  }
//}
//
//class _ViewModel {
//  final List<PostEntity> postsFollowing;
//
//  _ViewModel({
//    @required this.postsFollowing,
//  });
//}
//
//class _Body extends StatefulWidget {
//  final Store<AppState> store;
//  final _ViewModel vm;
//
//  _Body({
//    Key key,
//    @required this.store,
//    @required this.vm,
//  }) : super(key: key);
//
//  @override
//  _BodyState createState() => _BodyState();
//}
//
//class _BodyState extends State<_Body> {
//  final _scrollController = ScrollController();
//  var _isLoading = false;
//  var _isLoadingFollowingPosts = false;
//  var _isLoadingAllPosts = false;
//
//  @override
//  void initState() {
//    super.initState();
//
//    _scrollController.addListener(_scrollListener);
//
//    _loadPostsFollowing(recent: true, more: false);
//  }
//
//  @override
//  void dispose() {
//    _scrollController.removeListener(_scrollListener);
//
//    super.dispose();
//  }
//
//  void _scrollListener() {
//    if (_scrollController.position.pixels ==
//        _scrollController.position.maxScrollExtent) {
//      _loadPostsFollowing();
//    }
//  }
//
//  void _loadPostsFollowing({
//    bool recent = false,
//    bool more = true,
//    bool refresh = false,
//    Completer<Null> completer,
//  }) {
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
//    int beforeId;
//    if (more && widget.vm.postsFollowing.isNotEmpty) {
//      beforeId = widget.vm.postsFollowing.last.id;
//    }
//    int afterId;
//    if (recent && widget.vm.postsFollowing.isNotEmpty) {
//      afterId = widget.vm.postsFollowing.first.id;
//    }
//    widget.store.dispatch(postsFollowingAction(
//      beforeId: beforeId,
//      afterId: afterId,
//      refresh: refresh,
//      onSucceed: (posts) {
//        if (!refresh) {
//          setState(() {
//            _isLoading = false;
//          });
//        }
//
//        completer?.complete();
//      },
//      onFailed: (notice) {
//        if (!refresh) {
//          setState(() {
//            _isLoading = false;
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
//
//  Future<Null> _refresh() {
//    final completer = Completer<Null>();
//    _loadPostsFollowing(
//      more: false,
//      refresh: true,
//      completer: completer,
//    );
//    return completer.future;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
////        NestedScrollView(
////          controller: _scrollController,
////          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
////            _buildTabBar(context, innerBoxIsScrolled),
////          ],
////          body: _buildTabBarView(),
////        ),
////        Visibility(
////          visible: _isLoading,
////          child: Center(
////            child: CircularProgressIndicator(),
////          ),
////        ),
//      ],
//    );
//  }
//}

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({
    Key key,
    @required this.userId,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tabs = ['关注', '广场'];
  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        followingStatus: (store.state.status.followingStatus ?? [])
            .map<StatusEntity>((v) => store.state.status.statuses[v.toString()])
            .toList(),
        allStatus: store.state.status.statuses.values.toList(),
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
        bottomNavigationBar: MaTabBar(tabIndex: 0),
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
  var _isLoadingFollowingStatus = false;
  var _isLoadingAllStatus = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);

    _loadFollowingStatus(recent: true, more: false);
    _loadAllStatus(recent: true, more: false);
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
        _loadFollowingStatus();
      } else if (index == 1) {
        _loadAllStatus();
      }
    }
  }

  void _loadFollowingStatus({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<Null> completer,
  }) {
    if (_isLoadingFollowingStatus) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingFollowingStatus = true;
      });
    }

    String beforeId;
    if (more && widget.vm.followingStatus.isNotEmpty) {
      beforeId = widget.vm.followingStatus.last.id;
    }
    String afterId;
    if (recent && widget.vm.followingStatus.isNotEmpty) {
      afterId = widget.vm.followingStatus.first.id;
    }
    widget.store.dispatch(getFollowingStatusAction(
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (statuses) {
        if (!refresh) {
          setState(() {
            _isLoadingFollowingStatus = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingFollowingStatus = false;
          });
        }

        completer?.complete();

        createFailedSnackBar(context, notice: notice);
      },
    ));
  }

  void _loadAllStatus({
    bool recent = false,
    bool more = true,
    bool refresh = false,
    Completer<Null> completer,
  }) {
    if (_isLoadingAllStatus) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingAllStatus = true;
      });
    }

    String beforeId;
    if (more && widget.vm.allStatus.isNotEmpty) {
      beforeId = widget.vm.allStatus.last.id;
    }
    String afterId;
    if (recent && widget.vm.allStatus.isNotEmpty) {
      afterId = widget.vm.allStatus.first.id;
    }
    widget.store.dispatch(getPublicStatusAction(
      limit: 10,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (posts) {
        if (!refresh) {
          setState(() {
            _isLoadingAllStatus = false;
          });
        }

        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingAllStatus = false;
          });
        }

        completer?.complete();

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  Future<Null> _refreshFollowingStatuses() {
    final completer = Completer<Null>();
    _loadFollowingStatus(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildFollowingStatus(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshFollowingStatuses,
          child: CustomScrollView(
            key: PageStorageKey<String>('followingStatus'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => Status(
                    key: Key(widget.vm.followingStatus[index].id.toString()),
                    status: widget.vm.followingStatus[index],
                  ),
                  childCount: widget.vm.followingStatus.length,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isLoadingFollowingStatus,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Future<Null> _refreshAllStatuses() {
    final completer = Completer<Null>();
    _loadAllStatus(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildAllStatus(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshAllStatuses,
          child: CustomScrollView(
            key: PageStorageKey<String>('allStatus'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
//              SliverOverlapInjector(
//                handle:
//                NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => Status(
                    key: Key(widget.vm.allStatus[index].id.toString()),
                    status: widget.vm.allStatus[index],
                  ),
                  childCount: widget.vm.allStatus.length,
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isLoadingAllStatus,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
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
            if (name == '关注') {
              return _buildFollowingStatus(context);
            } else if (name == '广场') {
              return _buildAllStatus(context);
            } else {
              return null;
            }
          },
        ),
      ))
          .toList(),
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
        title: Text('首页', style: TextStyle(fontWeight: FontWeight.w700),),
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
