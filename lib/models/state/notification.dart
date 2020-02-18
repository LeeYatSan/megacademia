import 'package:megacademia/models/entity/notification.dart';
import 'package:megacademia/models/entity/status.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../entity/user.dart';

part 'notification.g.dart';

@JsonSerializable()
@immutable
class NotificationState {

  final List<NotificationEntity> notifications;
  final List<UserEntity> requestFollowAccounts;

  NotificationState({
    this.notifications = const[],
    this.requestFollowAccounts = const[],
  });

  factory NotificationState.fromJson(Map<String, dynamic> json) =>
      _$NotificationStateFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationStateToJson(this);

  NotificationState copyWith({
    List<NotificationEntity> notifications,
    List<UserEntity> requestFollowAccounts,
  }) =>
      NotificationState(
        notifications: notifications ?? this.notifications,
        requestFollowAccounts: requestFollowAccounts ?? this.requestFollowAccounts,
      );
}