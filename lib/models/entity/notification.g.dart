// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationEntity _$NotificationEntityFromJson(Map<String, dynamic> json) {
  return NotificationEntity(
    id: json['id'] as String,
    type: json['type'] as String,
    createdAt: json['created_at'] as String,
    account: json['account'] == null
        ? null
        : UserEntity.fromJson(json['account'] as Map<String, dynamic>),
    status: json['status'] == null
        ? null
        : StatusEntity.fromJson(json['status'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NotificationEntityToJson(NotificationEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'created_at': instance.createdAt,
      'account': instance.account,
      'status': instance.status,
    };
