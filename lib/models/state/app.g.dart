// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
    version: json['version'] as String,
    clientId: json['clientId'] as String,
    clientSecret: json['clientSecret'] as String,
    account: json['account'] == null
        ? null
        : AccountState.fromJson(json['account'] as Map<String, dynamic>),
    publish: json['publish'] == null
        ? null
        : PublishState.fromJson(json['publish'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : UserState.fromJson(json['user'] as Map<String, dynamic>),
    status: json['status'] == null
        ? null
        : StatusState.fromJson(json['status'] as Map<String, dynamic>),
    notification: json['notification'] == null
        ? null
        : NotificationState.fromJson(
            json['notification'] as Map<String, dynamic>),
    discovery: json['discovery'] == null
        ? null
        : DiscoveryState.fromJson(json['discovery'] as Map<String, dynamic>),
    search: json['search'] == null
        ? null
        : SearchState.fromJson(json['search'] as Map<String, dynamic>),
    hashTag: json['hashTag'] == null
        ? null
        : HashTagState.fromJson(json['hashTag'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'version': instance.version,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'account': instance.account,
      'publish': instance.publish,
      'user': instance.user,
      'status': instance.status,
      'notification': instance.notification,
      'discovery': instance.discovery,
      'search': instance.search,
      'hashTag': instance.hashTag,
    };
