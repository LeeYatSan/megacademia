import 'package:flutter/material.dart';

import '../../pages/pages.dart';
import '../../pages/home.dart';
import '../../pages/discovery.dart';
import '../../pages/notification.dart';
import '../../pages/tab.dart';
import '../../icons.dart';


class MaTabBar extends StatelessWidget{

  static final tabs = [
    {
      'title' : Text("首页"),
      'icon' : Icon(Icons.home),
      'builder' : (BuildContext context) => HomePage(),
    },
    {
      'title' : Text("发现"),
      'icon' : Icon(MaIcon.search),
      'builder' : (BuildContext context) => DiscoveryPage(),
    },
    {
      'title' : Text("通知"),
      'icon' : Icon(MaIcon.message_notation),
      'builder' : (BuildContext context) => NotificationPage(),
    },
  ];

  final int tabIndex;

  MaTabBar({
    Key key,
    this.tabIndex = 0
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => TabPage.globalKey.currentState.switchTab(index),
      items: tabs
          .map<BottomNavigationBarItem>(
            (v) => BottomNavigationBarItem(
          icon: v['icon'],
          title: v['title'],
        ),
      ).toList(),
    );
  }
}