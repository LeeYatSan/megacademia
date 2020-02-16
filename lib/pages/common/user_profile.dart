import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megacademia/actions/account.dart';
import 'package:megacademia/actions/actions.dart';
import 'package:megacademia/components/common/failed_snack_bar.dart';
import 'package:megacademia/components/common/user_tile.dart';
import 'package:megacademia/models/entity/relationship.dart';
import 'package:megacademia/pages/common/edit_user_info.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../icons.dart';
import '../../theme.dart';
import '../../pages/pages.dart';

class UserProfilePage extends StatelessWidget {

  final bool isSelf;
  final UserEntity user;
  final String accessToken;
//  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  static final _bodyKey = GlobalKey<_BodyState>();

  UserProfilePage({
    @required this.user,
    @required this.isSelf,
    this.accessToken = '',
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      key: _scaffoldKey,
      appBar: createAppBar(context,
          '${user.displayName == '' ? user.username : user.displayName}的主页'),
      body: _Body(user, isSelf, key: _bodyKey,
        store: StoreProvider.of<AppState>(context),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  UserEntity _user;
  final bool _isSelf;

  _Body(
      this._user,
      this._isSelf,
      {Key key,
        @required this.store,})
      : super(key: key);

  @override
  _BodyState createState() =>
      _BodyState(_user, _isSelf, store.state.user.currRelationship);
}

class _BodyState extends State<_Body> {
  UserEntity _user;
  final bool _isSelf;
  RelationshipEntity relationship;
  var _isLoading = false;
  final _scrollController = ScrollController();

  _BodyState(this._user, this._isSelf, this.relationship){
  }
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
//    _loadPostsFollowing(recent: true, more: false);
  }


  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
//      _loadPostsFollowing();
    }
  }

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

  Future<Null> _refresh() {
    final completer = Completer<Null>();
//    _loadPostsFollowing(
//      more: false,
//      refresh: true,
//      completer: completer,
//    );
    return completer.future;
  }

  Widget _createButton(UserEntity user){
    if(_isSelf){
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
                _user = widget.store.state.account.user;
              });
            });
          },
        )
      );
    }
    else{
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
                          relationship = relationship.copyWith(following: false);
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
                          relationship = relationship.copyWith(following: true);
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
            _user = widget.store.state.account.user;
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
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
                                height: 120.0,
                              ),
                              Container(
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/ma_header.png',
                                  image: _user.header,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                height: 120.0,
                              ),
                            ],
                          ),
                          onTap: (){
                            if(_isSelf)
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
                                              Text(_user.displayName == '' ?  _user.username : _user.displayName
                                                , style: TextStyle(fontSize: 16.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black),
                                              ),
                                              Opacity(
                                                opacity: _user.locked ? 1.0 : 0.0,
                                                child: Icon(Icons.lock, color: MaTheme.maYellows, size: 16,),
                                              ),
                                            ],
                                          ),
                                          Text('@${_user.username}',
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
                                          _createButton(_user),
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
                                child: Text(_user.note,
                                  style: TextStyle(fontSize: 12.0),),
                              ),
//                              Divider(height: 1.0,indent: 0.0,color: Colors.black12),
                              Container(
                                  height: 30.0,
                                  padding: EdgeInsets.only(left: 30.0, top: 5.0,
                                      right: 30.0, bottom: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Row(
                                          children: <Widget>[
                                            Text('关注  ', style: TextStyle(fontWeight: FontWeight.w700),),
                                            Text('${_user.followingCount}'),
                                          ],
                                        ),
                                        onTap: (){
                                          if(_user.id == widget.store.state.account.user.id){
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
                                            Text('${_user.followersCount}'),
                                          ],
                                        ),
                                        onTap: (){
                                          if(_user.id == widget.store.state.account.user.id){
                                            AppNavigate.push(context, FollowerPage());
                                          }
                                          else{
                                            createFailedSnackBar(context, msg: '暂时无法查看该用户的粉丝列表！');
                                          }
                                        },
                                      )
                                    ],
                                  )
                              ),
                              Divider(height: 1.0,indent: 0.0,color: Colors.black12),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 60.0, left: 30.0),
                      child: GestureDetector(
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundImage: _user.avatar == '' ? null
                                : NetworkImage(_user.avatar),
                            child: _user.avatar == '' ?
                            Image.asset('assets/images/missing.png') : null,
                            radius: 55.0,
                          ),
                        ),
                        onTap: (){
                          if(_isSelf)
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