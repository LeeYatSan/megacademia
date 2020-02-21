import 'package:megacademia/models/entity/status.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonSerializable()
@immutable
class StatusState {

  final Map<String, StatusEntity> statuses;
  final Map<String, List<String>> publishedStatus;
  final Map<String, List<String>> favouriteStatus;
  final Map<String, List<String>> markStatus;
  final List<String> followingStatus;

  StatusState({
    this.statuses = const {},
    this.publishedStatus = const {},
    this.favouriteStatus = const {},
    this.markStatus = const {},
    this.followingStatus = const [],
  });

  factory StatusState.fromJson(Map<String, dynamic> json) =>
      _$StatusStateFromJson(json);

  Map<String, dynamic> toJson() => _$StatusStateToJson(this);

  StatusState copyWith({
    Map<String, StatusEntity> statuses,
    Map<String, List<String>> publishedStatus,
    Map<String, List<String>> favouriteStatus,
    Map<String, List<String>> markStatus,
    List<String> followingStatus,
  }) =>
      StatusState(
        statuses: statuses ?? this.statuses,
        publishedStatus: publishedStatus ?? this.publishedStatus,
        favouriteStatus: favouriteStatus ?? this.favouriteStatus,
        markStatus: markStatus ?? this.markStatus,
        followingStatus: followingStatus ?? this.followingStatus,
      );
}