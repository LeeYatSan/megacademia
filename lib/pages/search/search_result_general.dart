import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../theme.dart';
import '../../pages/pages.dart';

class SearchResultGeneral extends StatefulWidget {

  String query;
  bool isInterest;

  SearchResultGeneral(
    this.query,
    {
      this.isInterest = false,
      Key key,
    }
  ) : super(key: key);

  @override
  _SearchResultGeneralState createState() => _SearchResultGeneralState();
}

class _SearchResultGeneralState extends State<SearchResultGeneral> {
  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        searchResult: store.state.search.searchResult,
        query: widget.query,
        accountId: store.state.account.user.id,
        isInterest: widget.isInterest,
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
  final SearchEntity searchResult;
  final String query;
  final String accountId;
  final bool isInterest;

  _ViewModel({
    @required this.searchResult,
    @required this.query,
    @required this.accountId,
    @required this.isInterest,
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
  final userScrollController = ScrollController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    _loadResult();
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
      _loadResult();
    }
  }

  void _loadResult({
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

    widget.store.dispatch(getSearchResultAction(
      widget.vm.query,
      isInterest: widget.vm.isInterest,
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
    _loadResult(completer: completer,);
    return completer.future;
  }

  Widget _buildUserList(){
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10,  bottom: 10, top: 10),
          child: Row(
            children: <Widget>[
              Icon(Icons.account_circle, color: MaTheme.maYellows,),
              SizedBox(width: 10,),
              Text('匹配用户',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          height: screenSize.height*0.1,
          width: screenSize.width,
          child: ListView.builder(
            shrinkWrap: true,
            controller: userScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.vm.searchResult.account.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) => _userItem(context, index),
          ),
        ),
        Divider(thickness: 1, color: MaTheme.greyLight,),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget _userItem(BuildContext context, int index){
    final UserEntity user = widget.vm.searchResult.account[index];
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: CircleAvatar(
                backgroundImage: user.avatar == '' ? null : NetworkImage(user.avatar),
                child: user.avatar == '' ? Image.asset('assets/images/missing.png') : null,
                radius: 25.0,
              ),
              onTap: Feedback.wrapForTap((){
                _goToProfile(context, user, widget.vm.accountId);
              }, context,),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  user.displayName == '' ? user.username : user.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToProfile(BuildContext context, UserEntity user, String accountId){
    print("进入个人主页");
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(relationshipAction(
        userId: user.id,
        onSucceed: (relationship){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(user: user,
                isSelf: accountId == user.id,)
          ));
        }));
  }

  Widget _buildStatusList(){
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10,  bottom: 10, top: 10),
          child: Row(
            children: <Widget>[
              Icon(Icons.comment, color: MaTheme.maYellows,),
              SizedBox(width: 10),
              Text('匹配动态',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Container(
          width: screenSize.width,
          child: ListView.builder(
            shrinkWrap: true,
            controller: userScrollController,
            itemCount: widget.vm.searchResult.statuses.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index)
              => Status(status: widget.vm.searchResult.statuses[index],),
          ),
        ),
        Divider(thickness: 1, color: MaTheme.greyLight,),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget _buildBody() {
    final result = widget.vm.searchResult;
    if(result == null || (result.account.length == 0 && result.statuses.length == 0)){
      return Container(
        child: Center(
          child: Text('没有「${widget.vm.query}」相关结果，请重新搜索～',
            style: TextStyle(color: MaTheme.maYellows),),
        ),
      );
    }
    else{
      return Container(
        child: Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: _refreshResult,
              child: ListView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  widget.vm.searchResult.account.length > 0 ?_buildUserList()
                      : Container(),
                  widget.vm.searchResult.statuses.length > 0 ? _buildStatusList()
                      : Container(
                          child: Center(child:
                            Text('没有「${widget.vm.query}」相关动态～',
                              style: TextStyle(color: MaTheme.maYellows),),
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(),
    );
  }
}
