import 'package:megacademia/models/models.dart';
import 'package:megacademia/models/state/notification.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config.dart';
import 'account.dart';
import 'publish.dart';
import 'user.dart';

part 'app.g.dart';

@JsonSerializable()
@immutable
class AppState {
  final String version;
  final String clientId;
  final String clientSecret;
  final AccountState account;
  final PublishState publish;
  final UserState user;
  final StatusState status;
  final NotificationState notification;

  AppState({
    String version,
    String clientId,
    String clientSecret,
    AccountState account,
    PublishState publish,
    UserState user,
    StatusState status,
    NotificationState notification,
  })  : this.version = version ?? MaConfig.packageInfo.version,
        this.clientId = clientId ?? '',
        this.clientSecret = clientSecret ?? '',
        this.account = account ?? AccountState(),
        this.publish = publish ?? PublishState(),
        this.user = user ?? UserState(),
        this.status = status ?? StatusState(),
        this.notification = notification ?? NotificationState();

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  AppState copyWith({
    String version,
    String clientId,
    String clientSecret,
    AccountState account,
    PublishState publish,
    UserState user,
    StatusState status,
    NotificationState notification
  }) =>
      AppState(
        version: version ?? this.version,
        clientId: clientId ?? this.clientId,
        clientSecret: clientSecret ?? this.clientSecret,
        account: account ?? this.account,
        publish: publish ?? this.publish,
        user: user ?? this.user,
        status: status ?? this.status,
        notification: notification ?? this.notification,
      );
}