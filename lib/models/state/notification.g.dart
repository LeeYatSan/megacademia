// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationState _$NotificationStateFromJson(Map<String, dynamic> json) {
  return NotificationState(
    notifications: (json['notifications'] as List)
        ?.map((e) => e == null
            ? null
            : NotificationEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    requestFollowAccounts: (json['requestFollowAccounts'] as List)
        ?.map((e) =>
            e == null ? null : UserEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NotificationStateToJson(NotificationState instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'requestFollowAccounts': instance.requestFollowAccounts,
    };
