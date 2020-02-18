import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final publishReducer = combineReducers<PublishState>([
  TypedReducer<PublishState, GetNodeCustomEmojisAction>(_getCustomEmojis),
]);

PublishState _getCustomEmojis(PublishState state, GetNodeCustomEmojisAction action) {
  var emojis = List<Emoji>.from(state.videos);
  return state.copyWith(
    emojis: emojis
  );
}