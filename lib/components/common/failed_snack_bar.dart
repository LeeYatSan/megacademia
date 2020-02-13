import 'package:flutter/material.dart';

import '../../models/models.dart';

Widget createFailedSnackBar(BuildContext context, {NoticeEntity notice, String msg}){
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(msg ?? notice.message),
    duration: notice != null ? notice.duration : Duration(seconds: 4),
  ));
}