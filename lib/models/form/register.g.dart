// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterForm _$RegisterFormFromJson(Map<String, dynamic> json) {
  return RegisterForm(
    username: json['username'] as String,
    password: json['password'] as String,
    email: json['email'] as String,
    agreement: json['agreement'] as String,
    locale: json['locale'] as String,
  );
}

Map<String, dynamic> _$RegisterFormToJson(RegisterForm instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'agreement': instance.agreement,
      'locale': instance.locale,
    };
