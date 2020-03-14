import 'package:megacademia/models/entity/tag.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models.dart';

part 'discovery.g.dart';

@JsonSerializable()
@immutable
class DiscoveryState {

  final List<TagEntity> tags;
  final List<InterestEntity> interests;
  final List<String> histories;

  DiscoveryState({
    this.tags = const[],
    this.interests = const[],
    this.histories = const[],
  });

  factory DiscoveryState.fromJson(Map<String, dynamic> json) =>
      _$DiscoveryStateFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoveryStateToJson(this);

  DiscoveryState copyWith({
    List<TagEntity> tags,
    List<InterestEntity> interests,
    List<String> histories,
  }) =>
      DiscoveryState(
        tags: tags ?? this.tags,
        interests: interests ?? this.interests,
        histories: histories ?? this.histories,
      );
}