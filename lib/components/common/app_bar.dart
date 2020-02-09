import 'package:flutter/material.dart';

import '../../icons.dart';
import '../../theme.dart';


AppBar createAppBar(BuildContext context, final title){
  return AppBar(
    title: Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
    leading: IconButton(
      icon: Icon(MaIcon.back, color: MaTheme.maYellows),
      onPressed: () => Navigator.of(context).pop(),
    ),
    backgroundColor: Colors.white,
  );
}