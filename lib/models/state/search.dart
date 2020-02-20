import 'package:megacademia/models/entity/search.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search.g.dart';

@JsonSerializable()
@immutable
class SearchState {

  final SearchEntity searchResult;

  SearchState({
    SearchEntity searchResult,
  }) : searchResult = searchResult;

  factory SearchState.fromJson(Map<String, dynamic> json) =>
      _$SearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);

  SearchState copyWith({
    SearchEntity searchResult,
  }) =>
      SearchState(
        searchResult: searchResult ?? this.searchResult,
      );
}