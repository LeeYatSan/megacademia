// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationshipEntity _$RelationshipEntityFromJson(Map<String, dynamic> json) {
  return RelationshipEntity(
    id: json['id'] as String,
    following: json['following'] as bool,
    showingReblogs: json['showing_reblogs'] as bool,
    followedBy: json['followed_by'] as bool,
    blocking: json['blocking'] as bool,
    blockedBy: json['blocking_by'] as bool,
    muting: json['muting'] as bool,
    mutingNotifications: json['muting_notifications'] as bool,
    requested: json['requested'] as bool,
    domainBlocking: json['domain_blocking'] as bool,
    endorsed: json['endorsed'] as bool,
  );
}

Map<String, dynamic> _$RelationshipEntityToJson(RelationshipEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'following': instance.following,
      'showing_reblogs': instance.showingReblogs,
      'followed_by': instance.followedBy,
      'blocking': instance.blocking,
      'blocking_by': instance.blockedBy,
      'muting': instance.muting,
      'muting_notifications': instance.mutingNotifications,
      'requested': instance.requested,
      'domain_blocking': instance.domainBlocking,
      'endorsed': instance.endorsed,
    };

RelationshipListEntity _$RelationshipListEntityFromJson(
    Map<String, dynamic> json) {
  return RelationshipListEntity(
    relationships: (json[''] as List)
        ?.map((e) => e == null
            ? null
            : RelationshipEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RelationshipListEntityToJson(
        RelationshipListEntity instance) =>
    <String, dynamic>{
      '': instance.relationships,
    };
