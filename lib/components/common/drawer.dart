import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:megacademia/pages/common/profile.dart';
import 'package:megacademia/pages/drawer/block_user.dart';
import 'package:megacademia/pages/drawer/follower.dart';
import 'package:megacademia/pages/drawer/following.dart';
import 'package:megacademia/pages/drawer/like.dart';
import 'package:megacademia/pages/drawer/mute_user.dart';
import 'package:megacademia/pages/drawer/setting.dart';

import '../../theme.dart';
import '../../icons.dart';
import '../../components/common/app_navigate.dart';
import '../../models/models.dart';

class MaDrawer extends StatelessWidget{

  MaDrawer({
    Key key,
  }) : super(key : key);

  Widget createMaListTile(BuildContext context, IconData icon,
      final title, Widget scene){
    return ListTile(
      leading: Icon(icon, color: MaTheme.maYellows, size: 28,),
      title: Text(title, style: TextStyle(color: Colors.grey,),),
      onTap: (){
        Navigator.pop(context);
        AppNavigate.push(context, scene);
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return StoreConnector<AppState, AccountState>(
      converter: (store) => store.state.account,
      builder: (context, accountState) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            MaDrawerHeader(),
//            createMaListTile(context, MaIcon.me, '个人主页',
//                UserProfilePage(
//                  isSelf: true,
//                  user: accountState.user,
//                  accessToken: accountState.accessToken,)
//            ),
            createMaListTile(context, MaIcon.me, '个人主页', ProfilePage(
              isSelf: true,
              user: accountState.user,
            )),
            createMaListTile(context, MaIcon.mute_user, '静默用户', MuteUserPage()),
            createMaListTile(context, MaIcon.block_user, '黑名单', BlockUserPage()),
            createMaListTile(context, MaIcon.like, '我点赞的', LikePage()),
            createMaListTile(context, MaIcon.setting, '设置', SettingPage()),
          ],
        ),
      ),
    );
  }
}

class MaDrawerHeader extends StatelessWidget{

  MaDrawerHeader({
    Key key,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: MaTheme.maYellows,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            child:
            Image.asset("assets/images/ma_header.png", fit: BoxFit.fill,
              width: double.infinity, height: double.infinity,),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: UserInfo(),
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget{

  UserInfo({
    Key key,
  }) : super(key : key);

  @override
  Widget build(BuildContext context){
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: store.state.account.user,
        accountState: store.state.account,
      ),
      distinct: true,
      builder: (context, vm) => Container(
        margin: EdgeInsets.only(left: 20.0, top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: CircleAvatar(
                backgroundImage: vm.user.avatar == '' ? null
                    : NetworkImage(vm.user.avatar),
                child: vm.user.avatar == '' ?
                Image.asset('assets/images/missing.png') : null,
                radius: 30.0,
              ),
              onTap: (){
                Navigator.pop(context);
                AppNavigate.push(context,
                    ProfilePage(
                      isSelf: true,
                      user: vm.accountState.user)
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(vm.user.displayName, style: TextStyle(fontSize: 18.0,
                          fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      Opacity(
                        opacity: vm.user.locked ? 1.0 : 0.0,
                        child: Icon(Icons.lock, color: Colors.black, size: 18,),
                      ),
                    ],
                  ),
                  Text("@${vm.user.username}", style: TextStyle(fontSize: 12.0,
                      fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Text(vm.user.followingCount.toString(),
                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),),
                                Text('关注',
                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),),
                              ],
                            ),
                            onTap: (){
                              Navigator.pop(context);
                              AppNavigate.push(context, FollowingPage());
                            },
                          ),
                          Spacer(flex: 1,),
                          GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Text(vm.user.followersCount.toString(),
                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),),
                                Text('粉丝',
                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),),
                              ],
                            ),
                            onTap: (){
                              Navigator.pop(context);
                              AppNavigate.push(context, FollowerPage());
                            },
                          ),
                          Spacer(flex: 8,),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ViewModel {
  final UserEntity user;
  final AccountState accountState;

  _ViewModel({
    @required this.user,
    @required this.accountState,
  });
}