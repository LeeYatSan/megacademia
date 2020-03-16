import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';

class LikePage extends StatefulWidget {

  LikePage({
    Key key,
  }) : super(key: key);

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        likeStatus: (store.state.status.favouriteStatus[store.state.account.user.id] ?? [])
            .map<StatusEntity>((v) => store.state.status.statuses[v]).toList(),
      ),
      builder: (context, vm) => Scaffold(
        body: _Body(
          key: _bodyKey,
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
      ),
    );
  }
}

class _ViewModel {
  final List<StatusEntity> likeStatus;

  _ViewModel({
    @required this.likeStatus,
  });
}

class _Body extends StatefulWidget {
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
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final scrollController = ScrollController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);

    _loadStatus(recent: true, more: false);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _loadStatus();
    }
  }

  void _loadStatus({
    bool recent = false,
    bool more = true,
    bool refresh = false,
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

    String beforeId;
    if (more && widget.vm.likeStatus.isNotEmpty) {
      beforeId = widget.vm.likeStatus.last.id;
    }
    String afterId;
    if (recent && widget.vm.likeStatus.isNotEmpty) {
      afterId = widget.vm.likeStatus.first.id;
    }
    widget.store.dispatch(getLikedStatusAction(
      userId: widget.store.state.account.user.id,
      beforeId: beforeId,
      afterId: afterId,
      refresh: refresh,
      onSucceed: (statuses) {
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

  Future<Null> _refreshStatus() {
    final completer = Completer<Null>();
    _loadStatus(
      more: false,
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(context, '我点赞的'),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: _refreshStatus,
              child: CustomScrollView(
                key: PageStorageKey<String>('likeStatus'),
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => Status(
                        key: Key(widget.vm.likeStatus[index].id.toString()),
                        status: widget.vm.likeStatus[index],
                      ),
                      childCount: widget.vm.likeStatus.length,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
