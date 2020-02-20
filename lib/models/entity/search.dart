import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:megacademia/models/entity/status.dart';
import 'package:megacademia/models/entity/tag.dart';
import 'package:megacademia/models/entity/user.dart';

part 'search.g.dart';

@JsonSerializable()
@immutable
class SearchEntity extends Object {
  @JsonKey(name: 'accounts')
  final List<UserEntity> account;

  @JsonKey(name: 'statuses')
  final List<StatusEntity> statuses;

  @JsonKey(name: 'hashtags')
  final List<TagEntity> hashtags;

  SearchEntity({
    this.account = const[],
    this.statuses =  const[],
    this.hashtags = const[]
  });

  SearchEntity copyWith({
    List<UserEntity> account,
    List<StatusEntity> statuses,
    List<TagEntity> hashtags,
  }) =>
      SearchEntity(
        account: account ?? this.account,
        statuses: statuses ?? this.statuses,
        hashtags: hashtags ?? this.hashtags,
      );

  factory SearchEntity.fromJson(Map<String, dynamic> json)=>
      _$SearchEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SearchEntityToJson(this);
}