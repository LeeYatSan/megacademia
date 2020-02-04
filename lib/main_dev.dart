import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

import 'app.dart';
import 'config.dart';
import 'factory.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  MaConfig.packageInfo = await PackageInfo.fromPlatform();
  MaConfig.debug = true;
  MaConfig.loggerLevel = Level.ALL;
  MaConfig.isLogAction = true;
  MaConfig.isLogApi = true;

  final store = await MaFactory().getStore();
  runApp(MaApp(store));
}