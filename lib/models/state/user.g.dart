// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserState _$UserStateFromJson(Map<String, dynamic> json) {
  return UserState(
    followingUsers: (json['followingUsers'] as List)
        ?.map((e) =>
            e == null ? null : UserEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    followers: (json['followers'] as List)
        ?.map((e) =>
            e == null ? null : UserEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    muteUsers: (json['muteUsers'] as List)
        ?.map((e) =>
            e == null ? null : UserEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    blockedUsers: (json['blockedUsers'] as List)
        ?.map((e) =>
            e == null ? null : UserEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    currRelationship: json['currRelationship'] == null
        ? null
        : RelationshipEntity.fromJson(
            json['currRelationship'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'followingUsers': instance.followingUsers,
      'followers': instance.followers,
      'muteUsers': instance.muteUsers,
      'blockedUsers': instance.blockedUsers,
      'currRelationship': instance.currRelationship,
    };
