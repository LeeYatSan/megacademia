import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
@immutable
class TagEntity extends Object {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'history')
  final List<HistoryEntity> history;

  TagEntity({
    this.name = '',
    this.url = '',
    this.history = const[]
  });

  TagEntity copyWith({
    String name,
    String url,
    List<HistoryEntity> history
  }) =>
      TagEntity(
        name: name ?? this.name,
        url: url ?? this.url,
        history: history ?? this.history
      );

  factory TagEntity.fromJson(Map<String, dynamic> json)=>
      _$TagEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TagEntityToJson(this);
}

@JsonSerializable()
@immutable
class HistoryEntity extends Object {

  @JsonKey(name: 'day')
  final String day;

  @JsonKey(name: 'uses')
  final String uses;

  @JsonKey(name: 'accounts')
  final String accounts;


  HistoryEntity({
    this.day  = '',
    this.uses = '',
    this.accounts = '',
  });

  HistoryEntity copyWith({
    String day,
    String uses,
    String accounts
  }) =>
      HistoryEntity(
        day: day ?? this.day,
        uses: uses ?? this.uses,
        accounts: accounts ?? this.accounts
      );

  factory HistoryEntity.fromJson(Map<String, dynamic> json)=>
      _$HistoryEntityFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryEntityToJson(this);
}