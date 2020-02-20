import 'package:megacademia/models/state/discovery.dart';
import 'package:megacademia/models/state/search.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final searchReducer = combineReducers<SearchState>([
  TypedReducer<SearchState, GetSearchResultAction>(_getSearchResult),
]);

SearchState _getSearchResult(SearchState state, GetSearchResultAction action) {
  return state.copyWith(
    searchResult: action.searchResult,
  );
}