import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:megacademia/components/common/failed_snack_bar.dart';
import 'package:megacademia/models/entity/relationship.dart';
import 'package:megacademia/pages/common/user_profile.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../models/models.dart';
import '../../theme.dart';
import '../../actions/actions.dart';
import '../../pages/pages.dart';

class UserTile extends StatelessWidget {
  final UserEntity user;
  final int type;
  final Store store;

  UserTile({
    Key key,
    @required this.user,
    @required this.type,
    @required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(user.id.toString()),
      onTap: (){
        store.dispatch(relationshipAction(
          userId: user.id,
          onSucceed: (relationship){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserProfilePage(
                  user: user, accessToken: null, isSelf: false,
                )
            ));
          }));
      },
      leading: CircleAvatar(
        backgroundImage: user.avatar == '' ? null
            : NetworkImage(user.avatar),
        child: user.avatar == '' ?
        Image.asset('assets/images/missing.png') : null,
        radius: 25.0,
      ),
      title: Row(
        children: <Widget>[
          Text(user.displayName == '' ? user.username : user.displayName),
          Opacity(
            opacity: user.locked ? 1.0 : 0.0,
            child: Icon(Icons.lock, color: MaTheme.maYellows),
          ),
        ],
      ),
      subtitle: Text(user.note, maxLines: 1, softWrap: true,),
      trailing: _getTrailing(context),
    );
  }

  Widget _getTrailing(BuildContext context){
    Widget trailing;
    switch(type){
      case 0:{
        trailing = _following(context);
      }break;
      case 1:{
        AppState currState = StoreProvider.of<AppState>(context).state;
        RelationshipEntity relationship = currState.user.currRelationship;
        trailing = relationship.following ? _following(context) : _follow(context);
      }break;
      case 2:{
        trailing = Container(
          padding: EdgeInsets.all(5.0),
          child: FlatButton(
            color: MaTheme.maYellows,
            child: Text('取消静默', style: TextStyle(color: Colors.white),),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),),
            onPressed: (){unmuteUser(context, user);},
          ),
        );
      }break;
      case 3:{
        trailing = Container(
          padding: EdgeInsets.all(5.0),
          child: FlatButton(
            color: MaTheme.maYellows,
            child: Text('取消拉黑', style: TextStyle(color: Colors.white),),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),),
            onPressed: (){unblockUser(context, user);},
          ),
        );
      }break;
    }
    return trailing;
  }

  Widget _following(BuildContext context){
    return Container(
      padding: EdgeInsets.all(5.0),
      child: FlatButton(
        color: MaTheme.maYellows,
        child: Text('已关注', style: TextStyle(color: Colors.white),),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),),
        onPressed: (){unfollowUser(context, user);},
      ),
    );
  }

  Widget _follow(BuildContext context){
    return Container(
      padding: EdgeInsets.all(5.0),
      child: OutlineButton(
        child: Text('关注', style: TextStyle(color: MaTheme.maYellows),),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),),
        borderSide: BorderSide(color: MaTheme.maYellows),
        onPressed: (){
          followUser(context, user);
          if(user.locked){
            createFailedSnackBar(context, msg:'对方为私密账户，已发送关注申请，请等待对方确认申请！');
          }
        },
      ),
    );
  }
}

void followUser(BuildContext context, UserEntity user) {
  StoreProvider.of<AppState>(context).dispatch(followUserAction(
    userId: user.id,
    onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(notice.message),
      duration: notice.duration,
    )),
  ));
}

void unfollowUser(BuildContext context, UserEntity user) {
  StoreProvider.of<AppState>(context).dispatch(unfollowUserAction(
    userId: user.id,
    onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(notice.message),
      duration: notice.duration,
    )),
  ));
}

void muteUser(BuildContext context, UserEntity user) {
  StoreProvider.of<AppState>(context).dispatch(muteUserAction(
    userId: user.id,
    onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(notice.message),
      duration: notice.duration,
    )),
  ));
}

void unmuteUser(BuildContext context, UserEntity user) {
  StoreProvider.of<AppState>(context).dispatch(unmuteUserAction(
    userId: user.id,
    onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(notice.message),
      duration: notice.duration,
    )),
  ));
}

void blockUser(BuildContext context, UserEntity user) {
  StoreProvider.of<AppState>(context).dispatch(blockUserAction(
    userId: user.id,
    onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(notice.message),
      duration: notice.duration,
    )),
  ));
}

void unblockUser(BuildContext context, UserEntity user) {
  StoreProvider.of<AppState>(context).dispatch(unblockUserAction(
    userId: user.id,
    onFailed: (notice) => Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(notice.message),
      duration: notice.duration,
    )),
  ));
}
