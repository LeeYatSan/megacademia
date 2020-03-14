import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megacademia/models/entity/Website.dart';
import 'package:megacademia/pages/common/hashTagTimeline.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../actions/actions.dart';
import '../theme.dart';
import '../icons.dart';
import 'search/search_delegate.dart';
import 'search/search_result_general.dart';

class DiscoveryPage extends StatefulWidget {

  DiscoveryPage({
    Key key,
  }) : super(key: key);

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  static final _bodyKey = GlobalKey<_BodyState>();

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        tags: store.state.discovery.tags,
        interests: store.state.discovery.interests,
      ),
      builder: (context, vm) => Scaffold(
        body: _Body(
          key: _bodyKey,
          store: StoreProvider.of<AppState>(context),
          vm: vm,
        ),
        bottomNavigationBar: MaTabBar(tabIndex: 1),
      ),
    );
  }
}

class _ViewModel {
  final List<TagEntity> tags;
  final List<InterestEntity> interests;

  _ViewModel({
    @required this.tags,
    @required this.interests,
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
  var _isLoadingTags = false;
  var _isLoadingInterests = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    _loadTags();
    _loadInterests();
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
        _loadTags();
        _loadInterests();
    }
  }

  void _loadTags({
    bool refresh = false,
    Completer<Null> completer,
  }) {
    if (_isLoadingTags) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingTags = true;
      });
    }

    widget.store.dispatch(getTrendsAction(
      onSucceed: () {
        if (!refresh) {
          setState(() {
            _isLoadingTags = false;
          });
        }
        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingTags = false;
          });
        }
        completer?.complete();
        createFailedSnackBar(context, notice: notice);
      },
    ));
  }

  Future<Null> _refreshTags() {
    final completer = Completer<Null>();
    _loadTags(
      completer: completer,
    );
    return completer.future;
  }

  void _loadInterests({
    bool refresh = false,
    Completer<Null> completer,
  }) {
    if (_isLoadingInterests) {
      completer?.complete();
      return;
    }

    if (!refresh) {
      setState(() {
        _isLoadingInterests = true;
      });
    }

    widget.store.dispatch(getInterestsAction(
      onSucceed: () {
        if (!refresh) {
          setState(() {
            _isLoadingInterests = false;
          });
        }
        completer?.complete();
      },
      onFailed: (notice) {
        if (!refresh) {
          setState(() {
            _isLoadingInterests = false;
          });
        }
        completer?.complete();
        createFailedSnackBar(context, notice: notice);
      },
    ));
  }

  Future<Null> _refreshInterests() {
    final completer = Completer<Null>();
    _loadInterests(
      completer: completer,
    );
    return completer.future;
  }

  Widget _buildHotPad() {
    final screenSize =  MediaQuery.of(context).size;
    return Container(
        height: screenSize.height*0.35,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.whatshot, color: MaTheme.redNormal,),
                SizedBox(width: 10,),
                Text('热门话题',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  child: Icon(Icons.refresh, color: MaTheme.maYellows, size: 12,),
                  onTap: _refreshTags,
                )
              ],
            ),
            SizedBox(height: 5,),
            Divider(height: 1, color: MaTheme.greyLight,),
            SizedBox(height: 5,),
            Expanded(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.vm.tags.length,
                    itemBuilder: (context, index){
                  return _buildHotPadItem(context, widget.vm, index);
                }),
            ),
            SizedBox(height: 5,),
            Divider(height: 1, color: MaTheme.greyLight,),
            SizedBox(height: 5,),
          ],
        )
    );
  }

  Widget _buildHotPadItem(BuildContext context, _ViewModel vm, int index){
    return GestureDetector(
      child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      MaIcon.rank[index],
                      SizedBox(width: 10,),
                      Text('${vm.tags[index].name}',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),),
                    ],
                  ),
                  Text('${vm.tags[index].history.length}人正在讨论',
                    style: TextStyle(fontSize: 10, color: MaTheme.greyNormal,),),
                ],
              ),
              SizedBox(height: 8,),
            ],
          )
      ),
      onTap: (){
        AppNavigate.push(
            context,
            HashTagPage(vm.tags[index].name),
        );
      },
    );
  }

  Widget _buildInterestPad() {
    final screenSize =  MediaQuery.of(context).size;
    return Container(
        height: screenSize.height*0.35*2.5,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.favorite_border, color: MaTheme.redNormal,),
                SizedBox(width: 10,),
                Text('近期兴趣',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  child: Icon(Icons.refresh, color: MaTheme.maYellows, size: 12,),
                  onTap: _refreshInterests,
                )
              ],
            ),
            SizedBox(height: 5,),
            Divider(height: 1, color: MaTheme.greyLight,),
            SizedBox(height: 5,),
            Expanded(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.vm.interests.length,
                  itemBuilder: (context, index){
                    return _buildInterestPadItem(context, widget.vm, index);
                  }),
            ),
            SizedBox(height: 5,),
            Divider(height: 1, color: MaTheme.greyLight,),
            SizedBox(height: 5,),
          ],
        )
    );
  }

  Widget _buildInterestPadItem(BuildContext context, _ViewModel vm, int index){
    return GestureDetector(
      child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 8,),
              Row(
                children: <Widget>[
                  MaIcon.rank[index],
                  SizedBox(width: 10,),
                  Text('${vm.interests[index].interestName}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),),
                ],
              ),
              SizedBox(height: 8,),
            ],
          )
      ),
      onTap: (){
        AppNavigate.push(
          context,
          SearchResultGeneral(vm.interests[index].interestName),
        );
      },
    );
  }

  Widget _buildWebsiteLink() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.link, color: MaTheme.maYellows,),
              SizedBox(width: 10,),
              Text('外部链接',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Divider(height: 1, color: MaTheme.greyLight,),
          SizedBox(height: 5,),
          LayoutBuilder(
            builder: (context, constraints) {
              final double margin = 5;
              final columns = 2;
              final width = (constraints.maxWidth - (columns - 1) * margin) / columns;
              final height = width;

              final children = websites
                  .asMap().entries.map<Widget>((entry) => Container(
                  width: width,
                  height: height,
                  child: GestureDetector(
                      onTap: (){
                        final flutterWebview = new FlutterWebviewPlugin();
                        flutterWebview.onUrlChanged.listen((url) {
                          _launchURL(url);
                        });
                        AppNavigate.push(
                            context,
                            WebviewScaffold(
                              url: entry.value.url,
                              appBar: createAppBar(context, entry.value.name),
                              withZoom: true,
                              withLocalStorage: true,
                            )
                        );
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.network(
                              entry.value.logoUrl,
                              width: width,
                              height: height*0.7,
                              fit: BoxFit.fitWidth,
                            ),
                            Divider(height: 1,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.language, color: MaTheme.greyNormal, size: 20,),
                                SizedBox(width: 5),
                                Text(entry.value.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: MaTheme.greyNormal, fontSize: 15),),
                              ],
                            )
                          ],
                        ),
                      )
                  ))
              ).toList();

              return Wrap(
                spacing: margin,
                runSpacing: margin,
                children: children,
              );
            },
          )
        ],
      ),
    );
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshTags,
          child: ListView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              _buildHotPad(),
              _buildInterestPad(),
              _buildWebsiteLink(),
            ],
          ),
        ),
        Visibility(
          visible: _isLoadingTags,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
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
        title: Text('发现', style: TextStyle(fontWeight: FontWeight.w700),),
        actions: <Widget>[
          UploadFile(),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 30.0),
              child: Icon(MaIcon.search, color: Colors.black,),
            ),
            onTap: ()=>showSearch(context: context,
                delegate: SearchBarDelegate(widget.vm.tags)),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      drawer: MaDrawer(),
      body: _buildBody(),
    );
  }
}
