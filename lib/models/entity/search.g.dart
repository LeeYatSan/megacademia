// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchEntity _$SearchEntityFromJson(Map<String, dynamic> json) {
  return SearchEntity(
    account: (json['accounts'] as List)
        ?.map((e) =>
            e == null ? null : UserEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    statuses: (json['statuses'] as List)
        ?.map((e) =>
            e == null ? null : StatusEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    hashtags: (json['hashtags'] as List)
        ?.map((e) =>
            e == null ? null : TagEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SearchEntityToJson(SearchEntity instance) =>
    <String, dynamic>{
      'accounts': instance.account,
      'statuses': instance.statuses,
      'hashtags': instance.hashtags,
    };
