import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'models/models.dart';
import 'theme.dart';
import 'config.dart';
import 'factory.dart';
import 'pages/pages.dart';

class MaApp extends StatelessWidget {

  final logger = MaFactory().getLogger('app');
  final Store<AppState> store;

  MaApp(this.store) {
    logger.info(
        'MaConfig(debug: ${MaConfig.debug}, loggerLevel: ${MaConfig.loggerLevel})');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: MaConfig.packageInfo.appName,
        theme: MaTheme.theme,
        routes: {
          '/': (context) => BootstrapPage(),
          '/login': (context) => LoginPage(),
          '/tab': (context) => TabPage(),
        },
      ),
    );
  }
}