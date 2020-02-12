import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:megacademia/components/common/user_list.dart';
import 'package:megacademia/models/models.dart';

import '../../components/common/app_bar.dart';


class BlockUserPage extends StatelessWidget {
  BlockUserPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserEntity>(
      converter: (store) => store.state.account.user,
      builder: (context, user) => Scaffold(
        appBar: createAppBar(context, '黑名单'),
        body: UserList(type: 3, user: user,),
      ),
    );
  }
}