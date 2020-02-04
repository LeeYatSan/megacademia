import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register.g.dart';

@immutable
@JsonSerializable()
class RegisterForm {
  String username;
  String password;
  String email;
  String agreement;
  String locale;

  RegisterForm({
    this.username = '',
    this.password = '',
    this.email = '',
    this.agreement = 'TRUE',
    this.locale = 'en',
  });

  factory RegisterForm.fromJson(Map<String, dynamic> json) =>
      _$RegisterFormFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterFormToJson(this);
}