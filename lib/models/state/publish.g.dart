// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publish.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublishState _$PublishStateFromJson(Map<String, dynamic> json) {
  return PublishState(
    text: json['text'] as String,
    images: (json['images'] as List)?.map((e) => e as String)?.toList(),
    videos: (json['videos'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PublishStateToJson(PublishState instance) =>
    <String, dynamic>{
      'text': instance.text,
      'images': instance.images,
      'videos': instance.videos,
    };
