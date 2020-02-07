import 'package:flutter/material.dart';
import 'package:megacademia/pages/drawer/setting.dart';

import '../../meta.dart';
import '../../theme.dart';
import '../../icons.dart';
import '../../components/common/app_navigate.dart';

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          MaDrawerHeader(),
          createMaListTile(context, MaIcon.me, '个人主页', Text('')),
          createMaListTile(context, MaIcon.mute_user, '静默用户', Text('')),
          createMaListTile(context, MaIcon.block_user, '黑名单', Text('')),
          createMaListTile(context, MaIcon.collect, '收藏', Text('')),
          createMaListTile(context, MaIcon.setting, '设置', SettingPage()),
        ],
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
    return Container(
      margin: EdgeInsets.only(left: 20.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: (MaMeta.user.avatar != '')
                ? NetworkImage(MaMeta.user.avatar)
                : AssetImage("assets/images/missing.png"),
            radius: 30.0,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(MaMeta.user.displayName, style: TextStyle(fontSize: 18.0,
                        fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    Opacity(
                      opacity: MaMeta.user.locked ? 1.0 : 0.0,
                      child: Icon(Icons.lock, color: Colors.black, size: 18,),
                    ),
                  ],
                ),
                Text("@${MaMeta.user.username}", style: TextStyle(fontSize: 12.0,
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
                            Text(MaMeta.user.followingCount.toString(),
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),),
                            Text('关注',
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),),
                          ],
                        ),
                        onTap: (){
                          print("Following");
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(flex: 1,),
                      GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Text(MaMeta.user.followersCount.toString(),
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),),
                            Text('粉丝',
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),),
                          ],
                        ),
                        onTap: (){
                          print("Follower");
                          Navigator.pop(context);
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
    );
  }
}