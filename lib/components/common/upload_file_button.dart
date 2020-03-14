import 'dart:async';
import 'package:flutter/material.dart';

import '../../icons.dart';

Widget uploadFile({var iconColor, var iconSize}){
  return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 30.0),
        child: Icon(MaIcon.uploadFile,
          color: iconColor ?? Colors.black,
          size: iconSize ?? 25,),
      ),
      onTap: ()=>print('Upload File')
  );
}


