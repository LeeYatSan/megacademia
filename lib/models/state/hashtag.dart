import 'package:megacademia/models/entity/search.dart';
import 'package:megacademia/models/entity/status.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hashtag.g.dart';

@JsonSerializable()
@immutable
class HashTagState {

  final String topic;
  final List<StatusEntity>statuses;

  HashTagState({
    this.topic = '',
    this.statuses = const[],
  });

  factory HashTagState.fromJson(Map<String, dynamic> json) =>
      _$HashTagStateFromJson(json);

  Map<String, dynamic> toJson() => _$HashTagStateToJson(this);

  HashTagState copyWith({
    String topic,
    List<StatusEntity>statuses
  }) =>
      HashTagState(
        topic: topic ?? this.topic,
        statuses: statuses ?? this.statuses,
      );
}