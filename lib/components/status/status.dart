import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../../config.dart';
import '../../pages/pages.dart';
import '../../actions/actions.dart';
import '../../utils/number.dart';
import '../../utils/date_until.dart';
import '../../components/components.dart';

class Status extends StatefulWidget {
  final StatusEntity status;

  Status({
    Key key,
    @required this.status,
  }) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  var _isLoading = false;

  void _likeStatus(BuildContext context, _ViewModel vm) {
    setState(() {
      _isLoading = true;
    });
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(likeStatusAction(
      statusId: widget.status.id,
      onSucceed: () {
        setState(() {
          _isLoading = false;
        });
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  void _unlikeStatus(BuildContext context, _ViewModel vm) {
    setState(() {
      _isLoading = true;
    });
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(unlikeStatusAction(
      statusId: widget.status.id,
      onSucceed: () {
        setState(() {
          _isLoading = false;
        });
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  void _boostStatus(BuildContext context, _ViewModel vm) {
    print('boost');
    setState(() {
      _isLoading = true;
    });
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(boostStatusAction(
      statusId: widget.status.id,
      onSucceed: () {
        setState(() {
          _isLoading = false;
        });
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  void _unboostStatus(BuildContext context, _ViewModel vm) {
    print('unboost');
    setState(() {
      _isLoading = true;
    });
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(unboostStatusAction(
      statusId: widget.status.id,
      onSucceed: () {
        setState(() {
          _isLoading = false;
        });
      },
      onFailed: (notice) {
        setState(() {
          _isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(notice.message),
          duration: notice.duration,
        ));
      },
    ));
  }

  void _deleteStatus(BuildContext context, _ViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: Text('确认删除', style: TextStyle(fontWeight: FontWeight.w700),),
        content: Text('是否确认删除动态？'),
        actions: <Widget>[
          FlatButton(
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(),
            child: Text('取消', style: TextStyle(fontWeight: FontWeight.w500),),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              Navigator.of(context, rootNavigator: true).pop();
              final store = StoreProvider.of<AppState>(context);
              store.dispatch(deleteStatusAction(
                status: widget.status,
                onSucceed: () {
                  setState(() {
                    _isLoading = false;
                  });
                },
                onFailed: (notice) {
                  setState(() {
                    _isLoading = false;
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(notice.message),
                    duration: notice.duration,
                  ));
                },
              ));
            },
            child: Text('确认', style: TextStyle(fontWeight: FontWeight.w500),),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _ViewModel vm) {
    return Container(
      padding: EdgeInsets.all(5),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: vm.creator.avatar == '' ? null
                        : NetworkImage(vm.creator.avatar),
                    child: vm.creator.avatar == '' ?
                    Image.asset('assets/images/missing.png') : null,
                    radius: 20.0,
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        vm.creator.displayName == '' ? vm.creator.username
                            : vm.creator.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: Feedback.wrapForTap((){
                _goToProfile(context, vm);
              }, context,),
            ),
          ),
          Text(DateUntil.dateTime(widget.status.createdAt.toString()),
              style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor)),
//          Text(
//            widget.status.createdAt.toString().substring(0, 16),
//            style: TextStyle(color: Theme.of(context).hintColor),
//          ),
        ],
      ),
    );
  }

  void _goToProfile(BuildContext context, _ViewModel vm){
    print("进入个人主页");
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(relationshipAction(
        userId: vm.creator.id,
        onSucceed: (relationship){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(user: vm.creator,
              isSelf: vm.accountState.user.id == vm.creator.id,)
          ));
        }));
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildText(String text) {
    return Container(
      padding: EdgeInsets.all(5),

      child: Html(
        data: text,
        onLinkTap: (url) {
          if(url.contains(MaApi.Tag)){
            AppNavigate.push(
              context,
              HashTagPage(url.split('/').last),
            );
          }
          else{
            final flutterWebview = new FlutterWebviewPlugin();
            flutterWebview.onUrlChanged.listen((url) {
              if(url.contains('bd')){
                _launchURL(url);
              }
              else{
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
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildCard(CardEntity card){
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        color: Colors.grey[50],
        width: screenSize.width - 30,
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              card.title,
              style: TextStyle(fontSize: 15),
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(card.providerName, style: TextStyle(fontSize: 13, color: Colors.grey))
          ],
        ),
      ),
      onTap: (){
        AppNavigate.push(
            context,
            WebviewScaffold(
              url: card.url,
              appBar: createAppBar(context, card.title),
              withZoom: true,
              withLocalStorage: true,
              clearCookies: true,
              invalidUrlRegex:'^ctrip.*',
            )
        );
      },
    );
  }

  Widget _buildImages(List<AttachmentEntity> images) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double margin = 5;
        final columns = 3;
        final width = (constraints.maxWidth - (columns - 1) * margin) / columns;
        final height = width;

        return Wrap(
          spacing: margin,
          runSpacing: margin,
          children: images
              .asMap()
              .entries
              .map<Widget>((entry) => GestureDetector(
              onTap: Feedback.wrapForTap(
                    () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImagesPlayerPage(
                    images: images
                        .map<AttachmentEntity>((image) => image)
                        .toList(),
                    initialIndex: entry.key,
                  ),
                )),
                context,
              ),
              child: CachedNetworkImage(
                imageUrl: entry.value.previewUrl,
                fit: BoxFit.cover,
                width: width,
                height: height,
              )))
              .toList(),
        );
      },
    );
  }

  Widget _buildVideo(AttachmentEntity video) {
    return VideoPlayerWithCover(video: video);
  }

  Widget _buildBody(BuildContext context) {
    StatusEntity status = widget.status;
    List<AttachmentEntity> attachments = status.mediaAttachments;
    bool hasCard = status.card != null;
    if(attachments.length == 0){
      return Column(
        children: <Widget>[
          _buildText(status.content),
          hasCard ? _buildCard(status.card) : Container(),
          Container(height: 10,),
        ],
      );
    }
    else if(attachments[0].type == 'image' || attachments[0].type == 'gifv'){
      return Column(
        children: <Widget>[
          _buildText(status.content),
          _buildImages(status.mediaAttachments),
          hasCard ? _buildCard(status.card) : Container(),
          Container(height: 10,),
        ],
      );
    }
    else if(attachments[0].type == 'video'){
      return Column(
        children: <Widget>[
          _buildText(status.content),
          _buildVideo(status.mediaAttachments[0]),
          hasCard ? _buildCard(status.card) : Container(),
          Container(height: 10,),
        ],
      );
    }
    else if(attachments[0].type == 'audio'){
      return Column(
        children: <Widget>[
          _buildText(status.content),
          hasCard ? _buildCard(status.card) : Container(),
          Container(height: 10,),
        ],
      );
    }
    else{
      return Container();
    }
  }

  void _reply(_ViewModel vm){
    AppNavigate.push(
        context,
        PublishPage(type: 0, inReplyTo: vm.creator,),
    );
  }

  Widget _buildFooter(BuildContext context, _ViewModel vm) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(5),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: screenSize.width*0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                widget.status.reblogsCount != 0
                    ? GestureDetector(
                  onTap: Feedback.wrapForTap(
                        () => _unboostStatus(context, vm),
                    context,
                  ),
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.repeat,
                            size: 15,
                            color: MaTheme.maYellows,
                          ),
                          Text('${numberWithProperUnit(widget.status.reblogsCount)}'
                            , style: MaTheme.statusFootText,
                          )
                        ],
                      )
                  ),
                )
                    : GestureDetector(
                  onTap: Feedback.wrapForTap(
                        () => _boostStatus(context, vm),
                    context,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.repeat,
                          size: 15,
                          color: Theme.of(context).hintColor,
                        ),
                        Text('${numberWithProperUnit(widget.status.reblogsCount)}'
                          , style: MaTheme.statusFootText,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: screenSize.width*0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.status.favouritesCount != 0
                    ? GestureDetector(
                  onTap: Feedback.wrapForTap(
                        () => _unlikeStatus(context, vm),
                    context,
                  ),
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            size: 15,
                            color: MaTheme.redLight,
                          ),
                          Text('${numberWithProperUnit(widget.status.favouritesCount)}'
                            , style: MaTheme.statusFootText,
                          )
                        ],
                      )
                  ),
                )
                    : GestureDetector(
                  onTap: Feedback.wrapForTap(
                        () => _likeStatus(context, vm),
                    context,
                  ),
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          size: 15,
                          color: Theme.of(context).hintColor,
                        ),
                        Text('${numberWithProperUnit(widget.status.favouritesCount)}'
                          , style: MaTheme.statusFootText,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: screenSize.width*0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Visibility(
                  visible: widget.status.account.id != vm.accountState.user.id,
                  child: GestureDetector(
                    onTap: Feedback.wrapForTap(
                          () => _reply(vm),
                      context,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Icon(
                        Icons.comment,
                        size: 15,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.status.account.id == vm.accountState.user.id,
                  child: GestureDetector(
                    onTap: Feedback.wrapForTap(
                          () => _deleteStatus(context, vm),
                      context,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Icon(
                        Icons.delete_outline,
                        size: 15,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        creator: widget.status.account ?? UserEntity(),
        accountState: store.state.account,
      ),
      builder: (context, vm) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                _buildHeader(context, vm),
                Divider(height: 1),
                _buildBody(context),
                Divider(height: 1),
                _buildFooter(context, vm),
              ],
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final UserEntity creator; // 嘟文作者
  final AccountState accountState;

  _ViewModel({
    @required this.creator,
    @required this.accountState,
  });
}
