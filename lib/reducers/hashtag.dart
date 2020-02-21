import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final hashTagReducer = combineReducers<HashTagState>([
  TypedReducer<HashTagState, GetHashTagStatusesAction>(_getHashStatuses),
]);

HashTagState _getHashStatuses(HashTagState state, GetHashTagStatusesAction action) {

  List<StatusEntity> statuses;
  if(state.topic == action.topic){
    statuses = state.statuses;
    statuses.insertAll(0, action.statuses);
  }
  else{
    statuses = action.statuses;
  }
  return state.copyWith(
    topic: action.topic,
    statuses: statuses,
  );
}