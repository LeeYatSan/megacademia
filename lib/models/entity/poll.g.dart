// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollEntity _$PollEntityFromJson(Map<String, dynamic> json) {
  return PollEntity(
    id: json['id'] as String,
    expiresAt: json['expires_at'] as String,
    expired: json['expired'] as bool,
    multiple: json['multiple'] as bool,
    votesCount: json['votes_count'] as int,
    votersCount: json['voters_count'] as int,
    voted: json['voted'] as bool,
    ownVotes: (json['own_votes'] as List)?.map((e) => e as int)?.toList(),
    options: (json['options'] as List)
        ?.map((e) =>
            e == null ? null : OptionEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    emojis: (json['emojis'] as List)
        ?.map(
            (e) => e == null ? null : Emoji.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PollEntityToJson(PollEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expires_at': instance.expiresAt,
      'expired': instance.expired,
      'multiple': instance.multiple,
      'votes_count': instance.votesCount,
      'voters_count': instance.votersCount,
      'voted': instance.voted,
      'own_votes': instance.ownVotes,
      'options': instance.options,
      'emojis': instance.emojis,
    };

OptionEntity _$OptionEntityFromJson(Map<String, dynamic> json) {
  return OptionEntity(
    title: json['title'] as String,
    votesCount: json['votes_count'] as int,
  );
}

Map<String, dynamic> _$OptionEntityToJson(OptionEntity instance) =>
    <String, dynamic>{
      'title': instance.title,
      'votes_count': instance.votesCount,
    };
