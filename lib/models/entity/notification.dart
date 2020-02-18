import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:megacademia/models/entity/status.dart';
import 'package:megacademia/models/entity/user.dart';

part 'notification.g.dart';

enum NotificationType { follow, mention, reblog, favourite}

@JsonSerializable()
@immutable
class NotificationEntity extends Object {
  static final typeNames = {
    NotificationType.follow: 'follow',
    NotificationType.mention: 'mention',
    NotificationType.reblog: 'reblog',
    NotificationType.favourite: 'favourite',
  };

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'account')
  final UserEntity account;

  @JsonKey(name: 'status')
  final StatusEntity status;

  NotificationEntity({
    this.id = '',
    this.type = '',
    this.createdAt = '',
    UserEntity account,
    StatusEntity status,
  }) : this.account = account ?? UserEntity(),
       this.status = status ?? StatusEntity();

  NotificationEntity copyWith({
    String id,
    String type,
    String createdAt,
    String account,
    String status
  }) =>
      NotificationEntity(
        id: id ?? this.id,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        account: account ?? this.account,
        status: status ?? this.status
      );

  factory NotificationEntity.fromJson(Map<String, dynamic> json)=>
      _$NotificationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationEntityToJson(this);
}