import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


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
          backgroundImage: MaMeta.user.avatar == '' ? null
              : NetworkImage(MaMeta.user.avatar),
          child: MaMeta.user.avatar == '' ?
            Image.asset('assets/images/missing.png') : null,
        )
    );
  }
}