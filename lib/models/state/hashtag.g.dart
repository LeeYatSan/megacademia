// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hashtag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HashTagState _$HashTagStateFromJson(Map<String, dynamic> json) {
  return HashTagState(
    topic: json['topic'] as String,
    statuses: (json['statuses'] as List)
        ?.map((e) =>
            e == null ? null : StatusEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$HashTagStateToJson(HashTagState instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'statuses': instance.statuses,
    };
