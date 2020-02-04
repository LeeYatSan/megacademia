// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'megacademia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaApiResponse _$MaApiResponseFromJson(Map<String, dynamic> json) {
  return MaApiResponse(
    code: json['code'] as int,
    message: json['message'] as String,
    data: json['data'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$MaApiResponseToJson(MaApiResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
