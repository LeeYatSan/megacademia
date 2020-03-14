// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestEntity _$InterestEntityFromJson(Map<String, dynamic> json) {
  return InterestEntity(
    interestName: json['interest_name'] as String,
    weight: (json['weight'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$InterestEntityToJson(InterestEntity instance) =>
    <String, dynamic>{
      'interest_name': instance.interestName,
      'weight': instance.weight,
    };
