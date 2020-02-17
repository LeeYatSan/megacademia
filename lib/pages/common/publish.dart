import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:megacademia/utils/regex_util.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../theme.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';
import '../pages.dart';
import '../../icons.dart';

class StatusType{
  static final textStatus = 0;
  static final imageStatus = 1;
  static final videoStatus = 2;
  static final names = ['文字', '图片', '视频'];
}

class StatusVisibility{
  static final public = 0;
  static final private = 1;
  static final direct = 2;
  static final names = ['公开', '粉丝', '私信'];
  static final value = ['public', 'private', 'direct'];
}

class PublishPage extends StatefulWidget {
  final int type;

  PublishPage({
    Key key,
    @required this.type
  }) : super(key: key);

  @override
  _PublishPageState createState() => _PublishPageState(type: type);
}

class _PublishPageState extends State<PublishPage> {
  final _bodyKey = GlobalKey<_BodyState>();
  int type;

  _PublishPageState({
    @required this.type
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        type: type,
        text: store.state.publish.text,
        images: store.state.publish.images,
        videos: store.state.publish.videos,
      ),
      builder: (context, vm) => Scaffold(
        appBar: AppBar(
          title: Text('发表见解'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(MaIcon.back, color: MaTheme.maYellows),
            onPressed: (){
              _bodyKey.currentState.widget.vm.images.clear();
              _bodyKey.currentState.widget.vm.videos.clear();
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            Container(
              child: PopupMenuButton<int>(
                child: Row(
                  children: <Widget>[
                    Icon(MaIcon.send, color: Colors.black,),
                    Text(StatusType.names[_bodyKey.currentState == null ? type : _bodyKey.currentState.widget.vm.type]),
                  ],
                ),
                onSelected: (int value){
                  setState(() {
                    type = value;
                  });
                  _bodyKey.currentState.setState(() {
                    _bodyKey.currentState.widget.vm.type = value;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: StatusType.textStatus,
                    child: Text(StatusType.names[StatusType.textStatus]),
                  ),
                  PopupMenuItem<int>(
                    value: StatusType.imageStatus,
                    child: Text(StatusType.names[StatusType.imageStatus]),
                  ),
                  PopupMenuItem<int>(
                    value: StatusType.videoStatus,
                    child: Text(StatusType.names[StatusType.videoStatus]),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              width: 90.0,
              child: FlatButton(
                child: Text('发表',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),),
                color: MaTheme.maYellows,
                onPressed: Feedback.wrapForTap(
                        () => _bodyKey.currentState.submit(), context),

              ),
            )
          ],
        ),
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
  int type;
  String text;
  final List<String> images;
  final List<String> videos;
  int visibility;

  _ViewModel({
    @required this.type,
    @required this.text,
    @required this.images,
    @required this.videos,
    this.visibility = 0,
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
  TextEditingController _textEditingController;
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: widget.vm.text);
  }

  void _saveText(String value) {
    setState(() {
      widget.vm.text = value.trim();
    });
    print('save text: $value');
//    widget.store.dispatch(PublishSaveAction(
//      text: value.trim(),
//    ));
  }

  Future _addFile() async {
    var source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('从相册选取'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              title: Text('用相机拍摄'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ));
    if (source == null) {
      return;
    }

    if (widget.vm.type == StatusType.imageStatus) {
      var file = await ImagePicker.pickImage(source: source);
      setState(() {
        widget.vm.images.add(file.path);
      });
    } else if (widget.vm.type == StatusType.videoStatus) {
      var file = await ImagePicker.pickVideo(source: source);
      setState(() {
        widget.vm.videos.add(file.path);
      });
    }
  }

  _removeFile(File file) {
    print('remove');
    if (widget.vm.type == StatusType.imageStatus) {
      setState(() {
        widget.vm.images.remove(file.path);
      });
    } else if (widget.vm.type == StatusType.videoStatus) {
      setState(() {
        widget.vm.images.remove(file.path);
      });
    }
  }

  void submit() {
    if (_isSubmitting) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('请勿重复提交'),
      ));
      return;
    }

    if ((widget.vm.type == StatusType.textStatus && widget.vm.text == '') ||
        (widget.vm.type == StatusType.imageStatus && widget.vm.images.length == 0) ||
        (widget.vm.type == StatusType.videoStatus && widget.vm.videos.length == 0)) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('内容不能为空'),
      ));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    _uploadMedia(
        (ids){
          if(ids != null)
            print('medias len: ${ids.length}');

          widget.store.dispatch(
              publishAction(
                status: widget.vm.text,
                mediaIds: ids,
                visibility: StatusVisibility.value[widget.vm.visibility],
                onSucceed: () {
                  setState(() {
                    _isSubmitting = false;
                  });

                  _textEditingController.clear();
                  widget.vm.images.clear();
                  widget.vm.videos.clear();
                  widget.vm.visibility = StatusVisibility.public;
                  AppNavigate.pop(context, param: '');
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('发表成功'),
                    duration: Duration(seconds: 2),
                  ));
                },
                onFailed: (notice) {
                  setState(() {
                    _isSubmitting = false;
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('发布失败：${notice.message}'),
                    duration: Duration(seconds: 2),
                  ));
                },
              )
          );
        }
    );
  }
  
  void _uploadMedia(void Function(List<String>) onSucceed,){
    List<String> mediaIds = List<String>();
    if(widget.vm.type == StatusType.imageStatus){
      int count = 0;
      int len = widget.vm.images.length;
      for(String curr in widget.vm.images){
        widget.store.dispatch(uploadMeidaAction(
          curr,
          onSucceed: (mediaId){
            mediaIds.add(mediaId);
            ++count;
            if(count == len){
              if (onSucceed != null) onSucceed(mediaIds);
            }
          },
          onFailed: (notice) => createFailedSnackBar(context, msg: '媒体上传失败'),
        ));
      }
    }
    else if(widget.vm.type == StatusType.videoStatus){
      int count = 0;
      int len = widget.vm.videos.length;
      for(String curr in widget.vm.videos){
        widget.store.dispatch(uploadMeidaAction(
          curr,
          onSucceed: (mediaId){
            mediaIds.add(mediaId);
            ++count;
            if(count == len){
              if (onSucceed != null) onSucceed(mediaIds);
            }
          },
          onFailed: (notice) => createFailedSnackBar(context, msg: '媒体上传失败'),
        ));
      }
    }
    else{
      if (onSucceed != null) onSucceed(mediaIds);
    }
  }

  Widget _buildImagePicker() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double margin = 5;
        final columns = 3;
        final width = (constraints.maxWidth - (columns - 1) * margin) / columns;
        final height = width;
        final images = widget.vm.images.map<File>((v) => File(v)).toList();

        final children = images
            .asMap()
            .entries
            .map<Widget>((entry) => Container(
              width: width,
              height: height,
              color: MaTheme.greyLight,
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: Feedback.wrapForTap(
                        () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImagesPlayerPage(
                          files: images,
                          initialIndex: entry.key,
                        ),
                      )), context),
                    child: Image.file(
                      entry.value,
                      width: width,
                      height: height,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: Feedback.wrapForTap(
                              () => _removeFile(entry.value), context),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.clear, color: MaTheme.whiteLight),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList();

        if (widget.vm.images.length < 6) {
          children.add(GestureDetector(
            onTap: Feedback.wrapForTap(_addFile, context),
            child: Container(
              width: width,
              height: height,
              color: MaTheme.greyLight,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: MaTheme.greyNormal,
                  size: 32,
                ),
              ),
            ),
          ));
        }

        return Wrap(
          spacing: margin,
          runSpacing: margin,
          children: children,
        );
      },
    );
  }

  Widget _buildVideoPicker() {
    final videos = widget.vm.videos.map<File>((v) => File(v));

    final children = videos
        .map<Widget>((video) => Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
          VideoPlayerWithControlBar(file: video),
          Container(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: Feedback.wrapForTap(() => _removeFile(video), context),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.clear, color: MaTheme.whiteLight),
              ),
            ),
          ),
        ],
      )).toList();

    if (widget.vm.videos.length < 1) {
      children.add(AspectRatio(
        aspectRatio: 16 / 9,
        child: GestureDetector(
          onTap: Feedback.wrapForTap(_addFile, context),
          child: Container(
            color: MaTheme.greyLight,
            child: Center(
              child: Icon(
                Icons.add,
                color: MaTheme.greyNormal,
                size: 32,
              ),
            ),
          ),
        ),
      ));
    }
    return Column(
      children: children,
    );
  }

  void _showAddLinkDialog() {
    TextEditingController _urlTextField = TextEditingController();
    final _urlFocus = FocusNode();
    bool _enableShortUrl = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(MaIcon.link),
                SizedBox(width: 10,),
                Text('添加外部URL链接'),
              ],
            ),
            content: StatefulBuilder(
              builder: (context, state){
                return Container(
                  height: 160,
                  child: Column(
                    children: <Widget>[
                      Text('请将外部URL链接黏贴到下面输入框',
                        style: TextStyle(color: MaTheme.greyNormal, fontSize: 15),),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0, right: 5.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'URL: http://',
                                labelStyle: TextStyle(
                                  color: MaTheme.maYellows,
                                  fontSize: 12,
                                ),
                                border: OutlineInputBorder(
                                  gapPadding: 5.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: MaTheme.maYellows,
                                  ),
                                ),
                              ),
                              maxLines: 1,
                              maxLengthEnforced: true,
                              controller: _urlTextField,
                              focusNode: _urlFocus,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                _urlFocus.unfocus();
                              },
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _enableShortUrl,
                                  activeColor: MaTheme.maYellows,
                                  onChanged: (value){
                                    state(() {
                                      _enableShortUrl = value;
                                    });
                                  },
                                ),
                                Text('启用短链接：节约字数，但链接仅一个月有效',
                                  style: TextStyle(color: MaTheme.greyNormal, fontSize: 10),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消'),
              ),
              FlatButton(
                onPressed: () {
                  if(_enableShortUrl){
                    widget.store.dispatch(transToShortLinkAction(
                      'http://${_urlTextField.text}',
                      onSucceed: (shortUrl){
                        _textEditingController.text =
                        '${_textEditingController.text}\n● $shortUrl';
                        widget.vm.text = _textEditingController.text;
                        Navigator.pop(context);
                      },
                      onFailed: (notice) => createFailedSnackBar(context, notice: notice),
                    ));
                  }
                  else{
                    _textEditingController.text =
                    '${_textEditingController.text}\n● http://${_urlTextField.text}';
                    widget.vm.text = _textEditingController.text;
                    Navigator.pop(context);
                  }
                },
                textColor: MaTheme.greyNormal,
                child: Text('添加'),
              ),
            ],
          );
        });
  }

  void _showBaiduNetDiskDialog() {
    TextEditingController _urlTextField = TextEditingController(text: '链接: https://pan.baidu.com/s/1zJQGVVAuRGWGY4x78y-_wQ 提取码: vpjd 复制这段内容后打开百度网盘手机App，操作更方便哦');
    final _urlFocus = FocusNode();
    bool _enableShortUrl = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(MaIcon.baiduNetDisk),
                SizedBox(width: 10,),
                Text('添加百度网盘分享链接'),
              ],
            ),
            content: StatefulBuilder(
              builder: (context, state){
                return Container(
                  height: 260,
                  child: Column(
                    children: <Widget>[
                      Text('请将原始百度网盘分享链接（建议分享永久有效链接）与提取码黏贴到下面输入框（百度网盘内点击分享资源，复制分享文字，保留中文及提取码）',
                        style: TextStyle(color: MaTheme.greyNormal, fontSize: 10),),
                      SizedBox(height: 10,),
                      Text('请确认您已安装「百度网盘APP」',
                        style: TextStyle(color: MaTheme.redDark, fontSize: 10),),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(MaIcon.baiduNetDisk, color: Colors.white, size: 15,),
                              SizedBox(width: 10,),
                              Text('进入百度网盘',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w700),),
                            ],
                          ),
                          color: Colors.blue,
                          onPressed: (){
                            AppNavigate.push(
                                context,
                                WebviewScaffold(
                                  url: 'https://pan.baidu.com/wap/welcome',
                                  appBar: createAppBar(context, '百度网盘'),
                                  withZoom: true,
                                  withLocalStorage: true,
                                  invalidUrlRegex:'^ctrip.*',
                                )
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        padding: EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0, right: 5.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                labelText: '分享链接',
                                labelStyle: TextStyle(
                                  color: MaTheme.maYellows,
                                  fontSize: 12,
                                ),
                                border: OutlineInputBorder(
                                  gapPadding: 5.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(
                                    color: MaTheme.maYellows,
                                  ),
                                ),
                              ),
                              maxLines: 1,
                              maxLengthEnforced: true,
                              controller: _urlTextField,
                              focusNode: _urlFocus,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                _urlFocus.unfocus();
                              },
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _enableShortUrl,
                                  activeColor: MaTheme.maYellows,
                                  onChanged: (value){
                                    state(() {
                                      _enableShortUrl = value;
                                    });
                                  },
                                ),
                                Text('启用短链接：节约字数，但链接仅一个月有效',
                                  style: TextStyle(color: MaTheme.greyNormal, fontSize: 10),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消'),
              ),
              FlatButton(
                onPressed: () {
                  var tmp = baiduNetDiskTrans(_urlTextField.text);
                  if(_enableShortUrl){
                    widget.store.dispatch(transToShortLinkAction(
                      '${tmp[0]}',
                      onSucceed: (shortUrl){
                        _textEditingController.text =
                        '${_textEditingController.text}\n[百度网盘]提取码：${tmp[1]}\n$shortUrl';
                        widget.vm.text = _textEditingController.text;
                        Navigator.pop(context);
                      },
                      onFailed: (notice) => createFailedSnackBar(context, notice: notice),
                    ));
                  }
                  else{
                    _textEditingController.text =
                    '${_textEditingController.text}\n[百度网盘]提取码：${tmp[1]}\n${tmp[0]}';
                    widget.vm.text = _textEditingController.text;
                    Navigator.pop(context);
                  }
                },
                textColor: MaTheme.greyNormal,
                child: Text('添加'),
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: ListView(
            padding: EdgeInsets.all(MaTheme.paddingSizeNormal),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '发表见解......',
                    border: InputBorder.none,
                  ),
                  onChanged: _saveText,
                  autofocus: widget.vm.type == StatusType.textStatus,
                  maxLength: 500,
                  maxLengthEnforced: true,
                  keyboardType: TextInputType.multiline,
                  minLines: 20,
                  maxLines: null,
//                  maxLines: widget.vm.type == StatusType.textStatus ? 10 : 5,
                  controller: _textEditingController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 10,),
                    PopupMenuButton<int>(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.remove_red_eye, color: MaTheme.greyNormal,),
                          Text(StatusVisibility.names[widget.vm.visibility],
                            style: TextStyle(color: MaTheme.greyNormal, fontSize: 10),),
                        ],
                      ),
                      onSelected: (int value){
                        setState(() {
                          widget.vm.visibility = value;
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: StatusVisibility.public,
                          child: ListTile(
                            title: Text(StatusVisibility.names[StatusVisibility.public],
                              style: TextStyle(fontWeight: FontWeight.w700),),
                            subtitle: Text('所有人都可见'),
                          )
                        ),
                        PopupMenuItem<int>(
                          value: StatusVisibility.private,
                          child: ListTile(
                            title: Text(StatusVisibility.names[StatusVisibility.private],
                              style: TextStyle(fontWeight: FontWeight.w700),),
                            subtitle: Text('仅粉丝可见'),
                          )
                        ),
                        PopupMenuItem<int>(
                          value: StatusVisibility.direct,
                          child: ListTile(
                            title: Text(StatusVisibility.names[StatusVisibility.private],
                              style: TextStyle(fontWeight: FontWeight.w700),),
                            subtitle: Text('仅私信「@用户」可见'),
                          )
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      child: Icon(MaIcon.link, color: MaTheme.greyNormal,),
                      onTap: () => _showAddLinkDialog(),
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      child: Icon(MaIcon.baiduNetDisk, color: MaTheme.greyNormal,),
                      onTap: () => _showBaiduNetDiskDialog(),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.vm.type == StatusType.imageStatus,
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: _buildImagePicker(),
                ),
              ),
              Visibility(
                visible: widget.vm.type == StatusType.videoStatus,
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: _buildVideoPicker(),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isSubmitting,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
