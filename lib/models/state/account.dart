import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../entity/user.dart';

part 'account.g.dart';

@JsonSerializable()
@immutable
class AccountState {
  final UserEntity user;
  final String accessToken;

  AccountState({
    UserEntity user,
    this.accessToken = '',
  }) :this.user = user ?? UserEntity();

  factory AccountState.fromJson(Map<String, dynamic> json) =>
      _$AccountStateFromJson(json);

  Map<String, dynamic> toJson() => _$AccountStateToJson(this);

  AccountState copyWith({
    UserEntity user,
    String accessToken,
  }) =>
      AccountState(
        user: user ?? this.user,
        accessToken: accessToken ?? this.accessToken,
      );
}
