import 'package:flutter/material.dart';

import '../../models/models.dart';

Widget createFailedSnackBar(BuildContext context, NoticeEntity notice){
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(notice.message),
    duration: notice.duration,
  ));
}