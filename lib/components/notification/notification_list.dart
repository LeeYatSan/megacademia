import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megacademia/components/components.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../common/failed_snack_bar.dart';

class NotificationList extends StatefulWidget {

  NotificationList({
    Key key,
  }) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        targetList: store.state.notification.notifications,
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
  final List<NotificationEntity> targetList;

  _ViewModel({
    @required this.targetList,
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
  final _scrollController = ScrollController();
  var _isLoading = false;


  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);

    _loadNotifications(recent: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void _loadNotifications({
    bool recent = false,
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

    widget.store.dispatch(getNotificationsAction(
      onSucceed: () {
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

  Future<Null> _refresh() {
    final completer = Completer<Null>();
    _loadNotifications(
      refresh: true,
      completer: completer,
    );
    return completer.future;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: (){return _refresh();},
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(height: 1),
            itemCount: widget.vm.targetList.length,
            itemBuilder: (context, index) => NotificationItem(
              key: Key(widget.vm.targetList[index].id),
              notification: widget.vm.targetList[index],
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

