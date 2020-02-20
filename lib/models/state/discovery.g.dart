// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoveryState _$DiscoveryStateFromJson(Map<String, dynamic> json) {
  return DiscoveryState(
    tags: (json['tags'] as List)
        ?.map((e) =>
            e == null ? null : TagEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    histories: (json['histories'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$DiscoveryStateToJson(DiscoveryState instance) =>
    <String, dynamic>{
      'tags': instance.tags,
      'histories': instance.histories,
    };
