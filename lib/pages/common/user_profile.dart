import 'dart:async';
import 'package:flutter/material.dart';
import 'package:megacademia/actions/account.dart';
import 'package:megacademia/components/common/failed_snack_bar.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';


import '../../components/common/app_bar.dart';
import '../../models/models.dart';
import '../../icons.dart';
import '../../theme.dart';

class UserProfilePage extends StatelessWidget {

  final bool isSelf;
  final UserEntity user;
  final String accessToken;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
      key: _scaffoldKey,
      appBar: createAppBar(context, '${user.displayName}的主页'),
      body: _Body(user, isSelf, key: _bodyKey,
        store: StoreProvider.of<AppState>(context),
      ),
    );
  }
}

//class _ViewModel {
////  final List<PostEntity> postsFollowing;
//  final UserEntity user;
//
//  _ViewModel({
////    @required this.postsFollowing,
//    @required this.user,
//  });
//}

class _Body extends StatefulWidget {
  final Store<AppState> store;
  final UserEntity _user;
  final bool _isSelf;

  _Body(
      this._user,
      this._isSelf,
      {Key key,
        @required this.store,})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState(_user, _isSelf);
}

class _BodyState extends State<_Body> {
  var _isLoading = false;
  final UserEntity _user;
  final bool _isSelf;
  final _scrollController = ScrollController();

  _BodyState(this._user, this._isSelf);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
//    _loadPostsFollowing(recent: true, more: false);
  }

//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Column(
//        children: <Widget>[
//          Stack(
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  Container(
//                    child: FadeInImage.assetNetwork(
//                      placeholder: 'assets/images/ma_header.png',
//                      image: _user.header,
//                      fit: BoxFit.cover,
//                      width: double.infinity,
//                    ),
//                    height: 120.0,
//                  ),
//                  Container(
//                    child: Column(
//                      children: <Widget>[
//                        Container(
//                          height: 60.0,
//                          padding: EdgeInsets.only(left: 160.0, top: 10.0, bottom: 10.0),
//                          child: Row(
//                            children: <Widget>[
//                              Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Text('${_user.displayName}',
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.w700,
//                                        fontSize: 16.0),
//                                  ),
//                                  Text('@${_user.username}',
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.w300,
//                                        fontSize: 12.0),
//                                  ),
//                                ],
//                              ),
//                              _createButton(),
//                            ],
//                          ),
//                        ),
//                        Container(
//                          width: double.infinity,
//                          margin: EdgeInsets.only(left: 30.0, right:20.0,
//                              top: 10.0, bottom: 30.0),
//                          child: Text(_user.note,
//                            style: TextStyle(fontSize: 12.0),),
//                        ),
//                        Divider(height: 1.0,indent: 0.0,color: Colors.grey),
//                      ],
//                    ),
//                  )
//                ],
//              ),
//              Container(
//                margin: EdgeInsets.only(top: 60.0, left: 30.0),
//                child: CircleAvatar(
//                  radius: 60.0,
//                  backgroundColor: Colors.white,
//                  child: CircleAvatar(
//                    backgroundImage: _user.avatar == '' ? null
//                        : NetworkImage(_user.avatar),
//                    child: _user.avatar == '' ?
//                    Image.asset('assets/images/missing.png') : null,
//                    radius: 55.0,
//                  ),
//                ),
//              )
//            ],
//          )
//        ],
//      ),
//    );
//  }

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

  Widget _createButton(){
    if(_isSelf){
      return Container(
        padding: EdgeInsets.only(left: 80.0, right: 30.0),
        child:  GestureDetector(
          child: Icon(MaIcon.edit, color: Colors.grey,),
          onTap: (){
            print('EDIT PROFILE');
          },
        ),
      );
    }
    else{

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
      print('上传一张图片${file.path}');
      widget.store.dispatch(accountEditImageAction(
        _isHeader, file.path,
        onSucceed: (){
          print('图片上传成功');
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
                            _addFile(true);
                          },
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 60.0,
                                padding: EdgeInsets.only(left: 160.0, top: 10.0, bottom: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${_user.displayName}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16.0),
                                        ),
                                        Text('@${_user.username}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    _createButton(),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left: 30.0, right:20.0,
                                    top: 10.0, bottom: 30.0),
                                child: Text(_user.note,
                                  style: TextStyle(fontSize: 12.0),),
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