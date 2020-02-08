import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../factory.dart';
import '../../models/models.dart';

class ProfileSideBarButtom extends StatelessWidget{

  ProfileSideBarButtom({
    Key key,
  }) : super(key : key);

  final _logger = MaFactory().getLogger('Maservice');

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        user: store.state.account.user,
      ),
      builder: (context , vm) => Container(
          child: CircleAvatar(
            backgroundImage: vm.user.avatar == '' ? null
                : NetworkImage(vm.user.avatar),
            child: vm.user.avatar == '' ?
            Image.asset('assets/images/missing.png') : null,
          )
      ),
    );
  }
}

class _ViewModel {
  final UserEntity user;

  _ViewModel({
    @required this.user,
  });
}