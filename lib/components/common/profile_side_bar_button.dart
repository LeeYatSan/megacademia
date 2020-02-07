import 'package:flutter/material.dart';

import '../../factory.dart';
import '../../meta.dart';
import '../../config.dart';

class ProfileSideBarButtom extends StatelessWidget{

  ProfileSideBarButtom({
    Key key,
  }) : super(key : key);

  final _logger = MaFactory().getLogger('Maservice');

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CircleAvatar(
            backgroundImage: (MaMeta.user.avatar != '')
                ? NetworkImage(MaMeta.user.avatar)
                : AssetImage("assets/images/missing.png")
        )
    );
  }
}