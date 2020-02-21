import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../theme.dart';

class HashTagPage extends StatefulWidget {

  String topic;

  HashTagPage(
      this.topic,
      {Key key,}
      ) : super(key: key);

  @override
  _HashTagPageState createState() => _HashTagPageState();
}

class _HashTagPageState extends State<HashTagPage> {
  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        topic: widget.topic,
        statuses: store.state.hashTag.statuses,
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
  String topic;
  List<StatusEntity> statuses;

  _ViewModel({
    @required this.topic,
    @required this.statuses,
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
    _loadStatuses();
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
      _loadStatuses(more: true);
    }
  }

  void _loadStatuses({
    bool refresh = false,
    bool more = false,
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

    String minId;
    if (more && widget.vm.statuses.isNotEmpty) {
      minId = widget.vm.statuses.last.id;
    }

    widget.store.dispatch(getHashTagStatusesAction(
      widget.vm.topic,
      minId: minId,
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

  Future<Null> _refreshResult() {
    final completer = Completer<Null>();
    _loadStatuses(completer: completer,);
    return completer.future;
  }

  Widget _buildBody() {
    return Container(
      child: Stack(
        children: <Widget>[
          widget.vm.statuses.length > 0 ?
          RefreshIndicator(
            onRefresh: _refreshResult,
            child: ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: widget.vm.statuses.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index)
                => Status(status: widget.vm.statuses[index],),
            ),
          ) : Container(
                child: Container(
                  height: MediaQuery.of(context).size.height-160,
                  alignment: Alignment.center,
                  child: Text('没有 #${widget.vm.topic} 相关动态～',
                    style: TextStyle(color: MaTheme.maYellows),),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context, '# ${widget.vm.topic}'),
      key: _scaffoldKey,
      body: _buildBody(),
    );
  }
}
