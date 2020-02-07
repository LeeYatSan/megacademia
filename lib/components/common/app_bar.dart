import 'package:flutter/material.dart';

import '../../icons.dart';


AppBar createAppBar(BuildContext context, final title){
  return AppBar(
    title: Text(title, style:TextStyle(color:  Colors.white)),
    leading: IconButton(
      icon: Icon(MaIcon.back, color: Colors.white,),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}