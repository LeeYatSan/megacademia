import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interest.g.dart';

@JsonSerializable()
@immutable
class InterestEntity extends Object {
  @JsonKey(name: 'interest_name')
  final String interestName;

  @JsonKey(name: 'weight')
  final double weight;


  InterestEntity({
    this.interestName = '',
    this.weight = 0.0
  });

  InterestEntity copyWith({
    String interestName,
    double weight
  }) =>
      InterestEntity(
        interestName: interestName ?? this.interestName,
        weight: weight ?? this.weight,
      );

  factory InterestEntity.fromJson(Map<String, dynamic> json)=>
      _$InterestEntityFromJson(json);

  Map<String, dynamic> toJson() => _$InterestEntityToJson(this);
}