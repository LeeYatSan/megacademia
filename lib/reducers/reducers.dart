import 'package:megacademia/reducers/discovery.dart';
import 'package:megacademia/reducers/notification.dart';
import 'package:megacademia/reducers/search.dart';

import '../models/models.dart';
import '../actions/actions.dart';
import 'account.dart';
import 'publish.dart';
import 'status.dart';
import 'user.dart';

AppState appReducer(AppState state, action) {
  if (action is ResetStateAction) {
    return state.copyWith(clientId: '');
  } else if (action is ResetPublishStateAction) {
    return state.copyWith(
      publish: PublishState(),
    );
  } else if(action is ClientInfoAction){
    return state.copyWith(
      clientId: action.clientId,
      clientSecret: action.clientSecret
    );
  } else {
    return state.copyWith(
      account: accountReducer(state.account, action),
      publish: publishReducer(state.publish, action),
      status: statusReducer(state.status, action),
      user: userReducer(state.user, action),
      notification: notificationReducer(state.notification, action),
      discovery: discoveryReducer(state.discovery, action),
      search: searchReducer(state.search, action),
    );
  }
}