import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'relationship.g.dart';

@JsonSerializable()
@immutable
class RelationshipEntity {

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'following')
  final bool following;

  @JsonKey(name: 'showing_reblogs')
  final bool showingReblogs;

  @JsonKey(name: 'followed_by')
  final bool followedBy;

  @JsonKey(name: 'blocking')
  final bool blocking;

  @JsonKey(name: 'blocking_by')
  final bool blockedBy;

  @JsonKey(name: 'muting')
  final bool muting;

  @JsonKey(name: 'muting_notifications')
  final bool mutingNotifications;

  @JsonKey(name: 'requested')
  final bool requested;

  @JsonKey(name: 'domain_blocking')
  final bool domainBlocking;

  @JsonKey(name: 'endorsed')
  final bool endorsed;

  const RelationshipEntity({
    this.id = '',
    this.following = false,
    this.showingReblogs = false,
    this.followedBy = false,
    this.blocking = false,
    this.blockedBy = false,
    this.muting = false,
    this.mutingNotifications = false,
    this.requested = false,
    this.domainBlocking = false,
    this.endorsed = false,
  });

  RelationshipEntity copyWith({
    String id,
    bool following,
    bool showingReblogs,
    bool followedBy,
    bool blocking,
    bool blockedBy,
    bool muting,
    bool mutingNotifications,
    bool requested,
    bool domainBlocking,
    bool endorsed,
  }) =>
      RelationshipEntity(
        id: id ?? this.id,
        following: following ?? this.following,
        showingReblogs: showingReblogs ?? this.showingReblogs,
        followedBy: followedBy ?? this.followedBy,
        blocking: blocking ?? this.blocking,
        blockedBy: blockedBy ?? this.blockedBy,
        muting: muting ?? this.muting,
        mutingNotifications: mutingNotifications ?? this.mutingNotifications,
        requested: requested ?? this.requested,
        domainBlocking: domainBlocking ?? this.domainBlocking,
        endorsed: endorsed ?? this.endorsed,
      );

  factory RelationshipEntity.fromJson(Map<String, dynamic> json)=>
      _$RelationshipEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipEntityToJson(this);
}

@JsonSerializable()
@immutable
class RelationshipListEntity {

  @JsonKey(name: '')
  final List<RelationshipEntity>relationships;


  const RelationshipListEntity({
    this.relationships = const[],
  });

  RelationshipListEntity copyWith({
    final List<RelationshipEntity> relationships
  }) =>
      RelationshipListEntity(
        relationships: relationships ?? this.relationships,
      );

  factory RelationshipListEntity.fromJson(Map<String, dynamic> json)=>
      _$RelationshipListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipListEntityToJson(this);
}