import 'package:megacademia/models/entity/relationship.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../entity/user.dart';

part 'user.g.dart';

@JsonSerializable()
@immutable
class UserState {
  final List<UserEntity> followingUsers;
  final List<UserEntity> followers;
  final List<UserEntity> muteUsers;
  final List<UserEntity> blockedUsers;
  final RelationshipEntity currRelationship;

  UserState({
    this.followingUsers = const [],
    this.followers = const [],
    this.muteUsers = const [],
    this.blockedUsers = const [],
    this.currRelationship
  });

  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateToJson(this);

  UserState copyWith({
    List<UserEntity> users,
    List<UserEntity> followingUsers,
    List<UserEntity> followers,
    List<UserEntity> muteUsers,
    List<UserEntity> blockedUsers,
    RelationshipEntity currRelationship
  }) =>
      UserState(
        followingUsers: followingUsers ?? this.followingUsers,
        followers: followers ?? this.followers,
        muteUsers: muteUsers ?? this.muteUsers,
        blockedUsers: blockedUsers ?? this.blockedUsers,
        currRelationship: currRelationship ?? this.currRelationship
      );
}