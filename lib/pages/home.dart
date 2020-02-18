import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megacademia/pages/common/publish.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../actions/actions.dart';
import '../theme.dart';
import '../icons.dart';

class HomePage extends StatefulWidget {

  HomePage({
    Key key,
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
        title: Text('首页', style: TextStyle(fontWeight: FontWeight.w700),),
        bottom: TabBar(
          tabs: widget.tabs.map<Widget>((name) => Tab(text: name)).toList(),
          indicatorColor: MaTheme.maYellows,
          labelColor: MaTheme.maYellows,
          unselectedLabelColor: Colors.black,
          labelStyle: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 30.0),
              child: PopupMenuButton<int>(
                child: Icon(MaIcon.send, color: Colors.black,),
                onSelected: (int value){
                  AppNavigate.push(
                      context,
                      PublishPage(type: value, ),
                      callBack: (data){
                        _refreshFollowingStatuses();
                        _refreshAllStatuses();
                      });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: StatusType.textStatus,
                    child: Text('文字'),
                  ),
                  PopupMenuItem<int>(
                    value: StatusType.imageStatus,
                    child: Text('图片'),
                  ),
                  PopupMenuItem<int>(
                    value: StatusType.videoStatus,
                    child: Text('视频'),
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      drawer: MaDrawer(),
      body: _buildTabBarView(),
    );
  }
}
