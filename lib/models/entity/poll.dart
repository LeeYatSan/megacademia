import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:megacademia/models/entity/user.dart';

part 'poll.g.dart';

@JsonSerializable()
@immutable
class PollEntity extends Object {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'expires_at')
  final String expiresAt;

  @JsonKey(name: 'expired')
  final bool expired;

  @JsonKey(name: 'multiple')
  final bool multiple;

  @JsonKey(name: 'votes_count')
  final int votesCount;

  @JsonKey(name: 'voters_count')
  final int votersCount;

  @JsonKey(name: 'voted')
  final bool voted;

  @JsonKey(name: 'own_votes')
  final List<int> ownVotes;

  @JsonKey(name: 'options')
  final List<OptionEntity> options;

  @JsonKey(name: 'emojis')
  final List<Emoji>emojis;

  PollEntity({
    this.id = '',
    this.expiresAt = '',
    this.expired = false,
    this.multiple = false,
    this.votesCount = 0,
    this.votersCount = 0,
    this.voted = false,
    this.ownVotes = const[],
    this.options = const[],
    this.emojis = const[]
  });

  PollEntity copyWith({
    String id,
    String expiresAt,
    bool expired,
    bool multiple,
    int votesCount,
    int votersCount,
    bool voted,
    List<int> ownVotes,
    List<OptionEntity> options,
    List<Emoji>emojis
  }) =>
      PollEntity(
        id: id ?? this.id,
        expiresAt: expiresAt ?? this.expiresAt,
        expired: expired ?? this.expired,
        multiple: multiple ?? this.multiple,
        votesCount: votesCount ?? this.votesCount,
        votersCount: votersCount ?? this.votersCount,
        voted: voted ?? this.voted,
        ownVotes: ownVotes ?? this.ownVotes,
        options: options ?? this.options,
        emojis: emojis ?? this.emojis
      );

  factory PollEntity.fromJson(Map<String, dynamic> json)=>
      _$PollEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PollEntityToJson(this);
}

@JsonSerializable()
@immutable
class OptionEntity extends Object {

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'votes_count')
  final int votesCount;

  OptionEntity({
    this.title  = '',
    this.votesCount = 0,
  });

  OptionEntity copyWith({
    String title,
    int votesCount,
  }) =>
      OptionEntity(
        title: title ?? this.title,
        votesCount: votesCount ?? this.votesCount
      );

  factory OptionEntity.fromJson(Map<String, dynamic> json)=>
      _$OptionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OptionEntityToJson(this);
}