// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentEntity _$AttachmentEntityFromJson(Map<String, dynamic> json) {
  return AttachmentEntity(
    id: json['id'] as String,
    type: json['type'] as String,
    url: json['url'] as String,
    previewUrl: json['preview_url'] as String,
    remoteUrl: json['remote_url'] as String,
    textUrl: json['text_url'] as String,
    meta: json['meta'] == null
        ? null
        : MetaEntity.fromJson(json['meta'] as Map<String, dynamic>),
    description: json['description'] as String,
    blurhash: json['blurhash'] as String,
  );
}

Map<String, dynamic> _$AttachmentEntityToJson(AttachmentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'url': instance.url,
      'preview_url': instance.previewUrl,
      'remote_url': instance.remoteUrl,
      'text_url': instance.textUrl,
      'meta': instance.meta,
      'description': instance.description,
      'blurhash': instance.blurhash,
    };

MetaEntity _$MetaEntityFromJson(Map<String, dynamic> json) {
  return MetaEntity(
    length: json['length'] as String,
    duration: (json['duration'] as num)?.toDouble(),
    fps: json['fps'] as int,
    size: json['size'] as String,
    width: (json['width'] as num)?.toDouble(),
    height: (json['height'] as num)?.toDouble(),
    aspect: (json['aspect'] as num)?.toDouble(),
    audioEncode: json['audio_encode'] as String,
    audioBitrate: json['audio_bitrate'] as String,
    audioChannels: json['audio_channels'] as String,
    original: json['original'] == null
        ? null
        : OriginalEntity.fromJson(json['original'] as Map<String, dynamic>),
    small: json['small'] == null
        ? null
        : SmallEntity.fromJson(json['small'] as Map<String, dynamic>),
    focus: json['focus'] == null
        ? null
        : FocusEntity.fromJson(json['focus'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MetaEntityToJson(MetaEntity instance) =>
    <String, dynamic>{
      'length': instance.length,
      'duration': instance.duration,
      'fps': instance.fps,
      'size': instance.size,
      'width': instance.width,
      'height': instance.height,
      'aspect': instance.aspect,
      'audio_encode': instance.audioEncode,
      'audio_bitrate': instance.audioBitrate,
      'audio_channels': instance.audioChannels,
      'original': instance.original,
      'small': instance.small,
      'focus': instance.focus,
    };

OriginalEntity _$OriginalEntityFromJson(Map<String, dynamic> json) {
  return OriginalEntity(
    width: (json['width'] as num)?.toDouble(),
    height: (json['height'] as num)?.toDouble(),
    size: json['size'] as String,
    aspect: (json['aspect'] as num)?.toDouble(),
    frameRate: json['frame_rate'] as String,
    duration: (json['duration'] as num)?.toDouble(),
    bitrate: json['bitrate'] as int,
  );
}

Map<String, dynamic> _$OriginalEntityToJson(OriginalEntity instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'size': instance.size,
      'aspect': instance.aspect,
      'frame_rate': instance.frameRate,
      'duration': instance.duration,
      'bitrate': instance.bitrate,
    };

SmallEntity _$SmallEntityFromJson(Map<String, dynamic> json) {
  return SmallEntity(
    width: (json['width'] as num)?.toDouble(),
    height: (json['height'] as num)?.toDouble(),
    size: json['size'] as String,
    aspect: (json['aspect'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$SmallEntityToJson(SmallEntity instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'size': instance.size,
      'aspect': instance.aspect,
    };

FocusEntity _$FocusEntityFromJson(Map<String, dynamic> json) {
  return FocusEntity(
    x: (json['x'] as num)?.toDouble(),
    y: (json['y'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$FocusEntityToJson(FocusEntity instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };
