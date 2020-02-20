// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchState _$SearchStateFromJson(Map<String, dynamic> json) {
  return SearchState(
    searchResult: json['searchResult'] == null
        ? null
        : SearchEntity.fromJson(json['searchResult'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchStateToJson(SearchState instance) =>
    <String, dynamic>{
      'searchResult': instance.searchResult,
    };
