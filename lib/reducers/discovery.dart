import 'package:megacademia/models/state/discovery.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final discoveryReducer = combineReducers<DiscoveryState>([
  TypedReducer<DiscoveryState, GetTrendsAction>(_getTrends),
  TypedReducer<DiscoveryState, SaveSearchHistoryAction>(_saveSearchHistoryAction),
  TypedReducer<DiscoveryState, ClearSearchHistoryAction>(_clearSearchHistoryAction),
]);

DiscoveryState _getTrends(DiscoveryState state, GetTrendsAction action) {
  var tagMap = Map.fromIterable(
    action.tags,
    key: (v) => (v as TagEntity),
    value: (v) => (v as TagEntity).history.length,
  );
  Comparator<TagEntity> tagComparator = (a, b)
    => a.history.length.compareTo(b.history.length);

  final List<TagEntity> tags = tagMap.keys.toList()..sort(tagComparator);

  return state.copyWith(
    tags: tags,
  );
}

DiscoveryState _saveSearchHistoryAction(DiscoveryState state, SaveSearchHistoryAction action) {

  List<String> histories = state.histories ?? List<String>();

  if(!histories.contains(action.query)){
    if(histories.length > 10){
      histories.removeAt(0);
    }
    histories.add(action.query);
  }

  return state.copyWith(
    histories: histories,
  );
}


DiscoveryState _clearSearchHistoryAction(DiscoveryState state, ClearSearchHistoryAction action) {

  print('clear');
  List<String> histories = List<String>();
  return state.copyWith(
    histories: histories,
  );
}