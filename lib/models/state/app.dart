import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config.dart';
import 'account.dart';
import 'publish.dart';
import 'post.dart';
import 'user.dart';

part 'app.g.dart';

@JsonSerializable()
@immutable
class AppState {
  final String version;
  final String clientId;
  final String clientSecret;
  final AccountState account;
  final PostState post;
  final PublishState publish;
  final UserState user;

  AppState({
    String version,
    String clientId,
    String clientSecret,
    AccountState account,
    PostState post,
    PublishState publish,
    UserState user,
  })  : this.version = version ?? MaConfig.packageInfo.version,
        this.clientId = clientId ?? '',
        this.clientSecret = clientSecret ?? '',
        this.account = account ?? AccountState(),
        this.post = post ?? PostState(),
        this.publish = publish ?? PublishState(),
        this.user = user ?? UserState();

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  AppState copyWith({
    String version,
    String clientId,
    String clientSecret,
    AccountState account,
    PostState post,
    PublishState publish,
    UserState user,
  }) =>
      AppState(
        version: version ?? this.version,
        clientId: clientId ?? this.clientId,
        clientSecret: clientSecret ?? this.clientSecret,
        account: account ?? this.account,
        post: post ?? this.post,
        publish: publish ?? this.publish,
        user: user ?? this.user,
      );
}