// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusState _$StatusStateFromJson(Map<String, dynamic> json) {
  return StatusState(
    statuses: (json['statuses'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k,
          e == null ? null : StatusEntity.fromJson(e as Map<String, dynamic>)),
    ),
    publishedStatus: (json['publishedStatus'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
    ),
    favouriteStatus: (json['favouriteStatus'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
    ),
    markStatus: (json['markStatus'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
    ),
    followingStatus:
        (json['followingStatus'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$StatusStateToJson(StatusState instance) =>
    <String, dynamic>{
      'statuses': instance.statuses,
      'publishedStatus': instance.publishedStatus,
      'favouriteStatus': instance.favouriteStatus,
      'markStatus': instance.markStatus,
      'followingStatus': instance.followingStatus,
    };

OthersStatusState _$OthersStatusStateFromJson(Map<String, dynamic> json) {
  return OthersStatusState(
    publishedStatus: (json['publishedStatus'] as List)
        ?.map((e) =>
            e == null ? null : StatusEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OthersStatusStateToJson(OthersStatusState instance) =>
    <String, dynamic>{
      'publishedStatus': instance.publishedStatus,
    };
