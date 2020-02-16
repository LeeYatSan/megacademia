import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megacademia/models/entity/relationship.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../icons.dart';
import '../../theme.dart';
import '../../pages/pages.dart';

class ProfilePage extends StatefulWidget {

  final bool isSelf;
  final UserEntity user;

  ProfilePage({
    Key key,
    @required this.user,
    @required this.isSelf,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _bodyKey = GlobalKey<_BodyState>();
//  final bool _isSelf;
//  final UserEntity _user;
//
//  _ProfilePageState(this._isSelf, this._user);

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        publishedStatus: (store.state.status.publishedStatus[widget.user.id] ?? [])
            .map<StatusEntity>((v) => store.state.status.statuses[v]).toList(),
        user: widget.user,
        isSelf: widget.isSelf,
        relationship: store.state.user.currRelationship,
      ),
      builder: (context, vm) => Scaffold(
        body: _Body(
          key: _bodyKey,
          store: StoreProvider.of<AppState>(context),
          vm: vm,
//          isSelf: _isSelf,
//          user: _user,
        ),
      ),
    );
  }
}

class _ViewModel {
  final List<StatusEntity> publishedStatus;
  final bool isSelf;
  UserEntity user;
  RelationshipEntity relationship;

  _ViewModel({
    @required this.publishedStatus,
    @required this.user,
    @required this.isSelf,
    @required this.relationship,
  });
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final _ViewModel vm;
//   bool isSelf;
//   UserEntity user;

  _Body({
    Key key,
    @required this.store,
    @required this.vm,
//    @required this.isSelf,
//    @required this.user,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState(vm);
}

class _BodyState extends State<_Body> {
//  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final scrollController = ScrollController();
  var _isLoading = false;
  _ViewModel vm;

  _BodyState(this.vm);

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
    if (more && vm.publishedStatus.isNotEmpty) {
      beforeId = vm.publishedStatus.last.id;
    }
    String afterId;
    if (recent && vm.publishedStatus.isNotEmpty) {
      afterId = vm.publishedStatus.first.id;
    }
    widget.store.dispatch(getPublishedStatusAction(
      userId: vm.user.id,
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

  Widget _createButton(UserEntity user){
    if(vm.isSelf){
      return Container(
          width: 20.0,
          height: 20.0,
          margin: EdgeInsets.only(left: 2.5, right: 2.5),
          child: OutlineButton(
            padding: EdgeInsets.all(0.0),
            highlightColor: Colors.white,
            child: Icon(MaIcon.edit, color: MaTheme.maYellows, size: 15.0,),
            shape: CircleBorder(),
            borderSide: BorderSide(color: MaTheme.maYellows),
            onPressed: (){
              AppNavigate.push(context, EditUserInfoPage(), callBack: (data){
                setState(() {
                  vm.user = widget.store.state.account.user;
                });
              });
            },
          )
      );
    }
    else{
      RelationshipEntity relationship = vm.relationship;
      return Container(
          width: 70.0,
          height: 20.0,
          padding: EdgeInsets.all(0.0),
          margin: EdgeInsets.only(left: 2.5, right: 2.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: 20.0,
                  height: 20.0,
                  margin: EdgeInsets.only(left: 2.5, right: 2.5),
                  child: OutlineButton(
                    padding: EdgeInsets.all(0.0),
                    highlightColor: Colors.white,
                    child: PopupMenuButton<int>(
                      child: Icon(Icons.more_horiz, color: MaTheme.maYellows, size: 15.0,),
                      onSelected: (int value){
                        switch(value){
                          case 0:{
                            if(relationship.muting){
                              unmuteUser(context, user);
                              setState(() {
                                relationship = relationship.copyWith(muting: false);
                              });
                            }
                            else{
                              muteUser(context, user);
                              setState(() {
                                relationship = relationship.copyWith(muting: true);
                              });
                            }
                          }break;
                          case 1:{
                            if(relationship.blocking){
                              unblockUser(context, user);
                              setState(() {
                                relationship = relationship.copyWith(blocking: false);
                              });
                            }
                            else{
                              blockUser(context, user);
                              setState(() {
                                relationship = relationship.copyWith(blocking: true);
                              });
                            }
                          }break;
                        }
                        print("mute: ${relationship.muting}");
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 0,
                          child: ListTile(
                            leading: Icon(MaIcon.mute_user, color: MaTheme.maYellows, size: 20.0,),
                            title: Text((relationship.muting ? '取消静默' : '加入静默名单'),
                              style: TextStyle(fontSize: 13.0),),
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: ListTile(
                            leading: Icon(MaIcon.block_user, color: MaTheme.maYellows, size: 20.0,),
                            title: Text((relationship.blocking ? '取消拉黑' : '加入黑名单'),
                              style: TextStyle(fontSize: 13.0),),
                          ),
                        ),
                      ],
                    ),
                    shape: CircleBorder(),
                    borderSide: BorderSide(color: MaTheme.maYellows),
                    onPressed: (){
                      print('more');
                    },
                  )
              ),
              Container(
                width:40.0,
                height: 20.0,
                margin: EdgeInsets.only(left: 1, right: 1),
                child: (relationship.following ?
                FlatButton(
                  padding: EdgeInsets.all(0.0),
                  color: MaTheme.maYellows,
                  highlightColor: Colors.white,
                  child: Text('已关注', style: TextStyle(color: Colors.white, fontSize: 10.0),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  onPressed: (){
                    unfollowUser(context, user);
                    setState(() {
                      vm.relationship = relationship.copyWith(following: false);
                    });
                  },
                ) :
                OutlineButton(
                  padding: EdgeInsets.all(0.0),
                  highlightColor: Colors.white,
                  child: Text('关注', style: TextStyle(color: MaTheme.maYellows, fontSize: 10.0),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  borderSide: BorderSide(color: MaTheme.maYellows),
                  onPressed: (){
                    followUser(context, user);
                    setState(() {
                      vm.relationship = relationship.copyWith(following: true);
                    });
                  },
                )
                ),
              ),
            ],
          )
      );
    }
  }

  Future _addFile(bool _isHeader) async {
    var source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
              child: Text(_isHeader ? '更换主页顶部背景' : '更换头像'),
            ),
            Divider(height: 1.0,indent: 0.0,color: Colors.black12),
            ListTile(
              leading: Icon(Icons.image, color: MaTheme.maYellows,),
              title: Text('从相册选取'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: MaTheme.maYellows,),
              title: Text('用相机拍摄'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            Container(height: 15.0,),
          ],
        ));
    if (source == null) {
      return;
    }

    var file = await ImagePicker.pickImage(source: source);
    if (file != null) {
      widget.store.dispatch(accountEditImageAction(
          _isHeader, file.path,
          onSucceed: (){
            build(context);
            setState(() {
              vm.user = widget.store.state.account.user;
            });
          },
          onFailed: (notice){
            if(notice.message.contains('422'))
              createFailedSnackBar(context,
                  msg: '[图片上传失败]:图片过大或格式错误，请更换图片！');
          }
      ));
    }
  }

  Widget _buildBody(){
    List<StatusEntity> publishedStatus = widget.vm.publishedStatus;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 75),
      child: Stack(
        children: <Widget>[
          RefreshIndicator(
            onRefresh: _refreshStatus,
            child: CustomScrollView(
              key: PageStorageKey<String>('${vm.user.id}Profile'),
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => Status(
                      key: Key(publishedStatus[index].id.toString()),
                      status: publishedStatus[index],
                    ),
                    childCount: publishedStatus.length,
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

  Widget _buildSilverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    final offset = MediaQuery.of(context).size.height * 0.1;
    UserEntity user = vm.user;
    bool isSelf = vm.isSelf;
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        expandedHeight: 300+offset,
        forceElevated: innerBoxIsScrolled,
        title: Text('${user.displayName == '' ? user.username
            : user.displayName}的主页',
          style: TextStyle(fontWeight: FontWeight.w700),),
        leading: IconButton(
          icon: Icon(MaIcon.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        pinned: true,
        backgroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(
          background:  Container(
//            margin: EdgeInsets.only(top: offset),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: Image.asset('assets/images/ma_header.png',
                                  fit: BoxFit.cover, width: double.infinity,),
                                height: 120.0+offset,
                              ),
                              Container(
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/ma_header.png',
                                  image: user.header,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                height: 120.0+offset,
                              ),
                            ],
                          ),
                          onTap: (){
                            if(isSelf)
                              _addFile(true);
                          },
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 160.0, top: 10.0, bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(user.displayName == '' ?
                                              user.username : user.displayName
                                                , style: TextStyle(fontSize: 16.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black),
                                              ),
                                              Opacity(
                                                opacity: user.locked ? 1.0 : 0.0,
                                                child: Icon(Icons.lock, color: MaTheme.maYellows, size: 16,),
                                              ),
                                            ],
                                          ),
                                          Text('@${user.username}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          _createButton(user),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left: 30.0, right:20.0,
                                    top: 10.0, bottom: 20.0),
//                                child: Text(user.note,
//                                  style: TextStyle(fontSize: 12.0),),
                                  child: Html(
                                    data: user.note,
                                    onLinkTap: (url) {
                                      AppNavigate.push(
                                          context,
                                          WebviewScaffold(
                                            url: url,
                                            appBar: createAppBar(context, '外部网页'),
                                            withZoom: true,
                                            withLocalStorage: true,
                                            clearCookies: true,
                                          )
                                      );
                                    },
                                  ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 30.0, top: 5.0,
                                      right: 30.0, bottom: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
//                                      Row(
//                                        children: <Widget>[
//                                          Text('动态  ', style: TextStyle(fontWeight: FontWeight.w700),),
//                                          Text('${widget.vm.publishedStatus.length}'),
//                                        ],
//                                      ),
                                      GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Text('关注  ', style: TextStyle(fontWeight: FontWeight.w700),),
                                            Text('${user.followingCount}'),
                                          ],
                                        ),
                                        onTap: (){
                                          if(user.id == widget.store.state.account.user.id){
                                            AppNavigate.push(context, FollowingPage());
                                          }
                                          else{
                                            createFailedSnackBar(context, msg: '暂时无法查看该用户的关注列表！');
                                          }
                                        },
                                      ),
                                      GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Text('粉丝  ', style: TextStyle(fontWeight: FontWeight.w700),),
                                            Text('${user.followersCount}'),
                                          ],
                                        ),
                                        onTap: (){
                                          if(user.id == widget.store.state.account.user.id){
                                            AppNavigate.push(context, FollowerPage());
                                          }
                                          else{
                                            createFailedSnackBar(context, msg: '暂时无法查看该用户的粉丝列表！');
                                          }
                                        },
                                      ),
                                    ],
                                  )
                              ),
                              Divider(height: 1.0,indent: 0.0,color: Colors.black12),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 60.0+offset, left: 30.0),
                      child: GestureDetector(
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundImage: user.avatar == '' ? null
                                : NetworkImage(user.avatar),
                            child: user.avatar == '' ?
                            Image.asset('assets/images/missing.png') : null,
                            radius: 55.0,
                          ),
                        ),
                        onTap: (){
                          if(isSelf)
                            _addFile(false);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            _buildSilverAppBar(context, innerBoxIsScrolled),
          ],
          body: _buildBody(),
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
