import 'package:flutter/material.dart';
import 'package:megacademia/icons.dart';
import 'package:megacademia/models/entity/notification.dart';
import 'package:meta/meta.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';


import '../../models/models.dart';
import '../../theme.dart';
import '../../actions/actions.dart';
import '../../pages/pages.dart';
import '../../components/components.dart';
import '../../utils/date_until.dart';

class FollowRequestItem extends StatefulWidget {
  final UserEntity user;
  final NotificationEntity notification;

  FollowRequestItem({
    Key key,
    @required this.user,
    this.notification,
  }) : super(key: key);

  @override
  _FollowRequestItemState createState() => _FollowRequestItemState();
}

class _FollowRequestItemState extends State<FollowRequestItem> {
  var _isLoading = false;

  Widget _buildHeader(BuildContext context, _ViewModel vm){
    if(vm.notification == null){
      return _buildHeaderScaffold(context, vm, '请求关注你', Icons.add_circle_outline);
    }
    else{
      switch(vm.notification.type){
        case 'mention':{
          return _buildHeaderScaffold(context, vm, '提到你', Icons.alternate_email);
        }break;
        case 'reblog':{
          return _buildHeaderScaffold(context, vm, '快速转发了你的动态', Icons.repeat);
        }break;
        case 'follow':{
          return _buildHeaderScaffold(context, vm, '开始关注你', Icons.visibility);
        }break;
        case 'favourite':{
          return _buildHeaderScaffold(context, vm, '赞了你的动态',
              Icons.favorite, iconColor: MaTheme.redLight);
        }break;
      }
    }
  }

  Widget _buildHeaderScaffold(BuildContext context, _ViewModel vm,
      String text, IconData iconData, {Color iconColor}){
    return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Icon(iconData, size: 20, color: iconColor ?? MaTheme.maYellows,),
            SizedBox(width: 10),
            Text('${vm.user.displayName != '' ? vm.user.displayName : vm.user.username}$text',
              style: TextStyle(color: MaTheme.greyNormal, fontSize: 20),),
            SizedBox(width: 10),
            GestureDetector(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: vm.user.avatar == '' ? null
                        : NetworkImage(vm.user.avatar),
                    child: vm.user.avatar == '' ?
                    Image.asset('assets/images/missing.png') : null,
                    radius: 20.0,
                  ),
                  Flexible(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            Text(
                              vm.user.displayName == '' ? vm.user.username
                                  : vm.user.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '@${vm.user.displayName == '' ? vm.user.username
                                  : vm.user.displayName}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: MaTheme.greyNormal,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  Text(DateUntil.dateTime(widget.notification.status.createdAt.toString()),
                      style: TextStyle(fontSize: 13, color: Theme.of(context).hintColor)),
                ],
              ),
              onTap: Feedback.wrapForTap((){
                _goToProfile(context, vm);
              }, context,),
            ),
          ],
        )
    );
  }

//  void _delete(){
//    final store = StoreProvider.of<AppState>(context);
//    store.dispatch(getNotificationsAction(
//      onSucceed: (){
//        setState(() {
//          _isLoading = true;
//        });
//      },
//    ));
//  }

  void _goToProfile(BuildContext context, _ViewModel vm){
    print("进入个人主页");
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(relationshipAction(
        userId: vm.user.id,
        onSucceed: (relationship){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfilePage(user: vm.user,
                isSelf: vm.accountState.user.id == vm.user.id,)
          ));
        }));
  }

  Widget _buildBody(BuildContext context, _ViewModel vm){
    if(vm.notification != null){
      if(vm.notification.type == NotificationEntity.typeNames[NotificationType.follow]){
        return Container();
      }
      else if(vm.notification.type == NotificationEntity.typeNames[NotificationType.mention]){
        return Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 4,
                child: _buildStatusBody(context),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  child: Icon(MaIcon.repost, size: 20, color: MaTheme.greyNormal,),
                  onTap: ()=>print('repost'),
                ),
              ),
            ],
          ),
        );
      }
      else{
        return Container(
          padding: EdgeInsets.all(5),
          child: _buildStatusBody(context),
        );
      }
    }
    else return Container();
  }

  Widget _buildText(String text) {
    return Container(
      padding: EdgeInsets.all(5),

      child: Html(
        data: text,
        onLinkTap: (url) {
          final flutterWebview = new FlutterWebviewPlugin();
          flutterWebview.onUrlChanged.listen((url) {
            _launchURL(url);
          });
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
    );
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  Widget _buildStatusBody(BuildContext context) {
    StatusEntity status = widget.notification.status;
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: widget.user,
        notification: widget.notification,
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
                _buildBody(context, vm),
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
  UserEntity user;
  NotificationEntity notification;
  AccountState accountState;

  _ViewModel({
    @required this.user,
    this.notification,
    @required this.accountState,
  });
}