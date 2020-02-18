import 'package:flutter/material.dart';
import 'package:megacademia/models/entity/notification.dart';
import 'package:meta/meta.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';


class NotificationItem extends StatefulWidget {
  final NotificationEntity notification;

  NotificationItem({
    Key key,
    @required this.notification,
  }) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  var _isLoading = false;

  Widget _buildHeader(BuildContext context, _ViewModel vm){
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

  Widget _buildHeaderScaffold(BuildContext context, _ViewModel vm,
      String text, IconData iconData, {Color iconColor}){
    return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Icon(iconData, size: 15, color: iconColor ?? MaTheme.maYellows,),
                SizedBox(width: 10),
                Text('${vm.notification.account.displayName != '' ?
                vm.notification.account.displayName : vm.notification.account.username}$text',
                  style: TextStyle(color: MaTheme.greyNormal, fontSize: 10),),
              ],
            ),
            GestureDetector(
              child: Icon(Icons.clear, size: 20, color: MaTheme.greyNormal,),
              onTap: _delete,
            )
          ],
        )
    );
  }

  Widget _buildBody(BuildContext context, _ViewModel vm){
    if(widget.notification.type == NotificationEntity.typeNames[NotificationType.follow]) {
      return Container(
        child: UserTile(
          key: Key(widget.notification.account.id),
          user: widget.notification.account,
          type: 1,
          store: StoreProvider.of<AppState>(context),
        ),
      );
    }
    else return Status(
      key: Key(widget.notification.status.id),
      status: widget.notification.status,
    );
  }

  void _delete(){
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(dismissSingleNotificationAction(
      notificationId: widget.notification.id,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
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
  NotificationEntity notification;
  AccountState accountState;

  _ViewModel({
    this.notification,
    @required this.accountState,
  });
}