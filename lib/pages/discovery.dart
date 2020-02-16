import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../components/components.dart';

class DiscoveryPage extends StatelessWidget {
  DiscoveryPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发现', style: TextStyle(fontWeight: FontWeight.w700),),
      ),
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}