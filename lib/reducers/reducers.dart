import '../models/models.dart';
import '../actions/actions.dart';
import 'account.dart';
import 'publish.dart';
import 'post.dart';
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
      post: postReducer(state.post, action),
      user: userReducer(state.user, action),
    );
  }
}