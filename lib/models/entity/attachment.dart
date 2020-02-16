import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

@JsonSerializable()
@immutable
class AttachmentEntity extends Object {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'preview_url')
  final String previewUrl;

  @JsonKey(name: 'remote_url')
  final String remoteUrl;

  @JsonKey(name: 'text_url')
  final String textUrl;

  @JsonKey(name: 'meta')
  final MetaEntity meta;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'blurhash')
  final String blurhash;

  AttachmentEntity({
    this.id = '',
    this.type = '',
    this.url = '',
    this.previewUrl = '',
    this.remoteUrl = '',
    this.textUrl = '',
    this.meta,
    this.description = '',
    this.blurhash = ''
  });

  AttachmentEntity copyWith({
    String id,
    String type,
    String url,
    String previewUrl,
    String remoteUrl,
    String textUrl,
    MetaEntity meta,
    String description,
    String blurhash
  }) =>
      AttachmentEntity(
        id: id ?? this.id,
        type: type ?? this.type,
        url: url ?? this.url,
        previewUrl: previewUrl ?? this.previewUrl,
        remoteUrl: remoteUrl ?? this.remoteUrl,
        textUrl: textUrl ?? this.textUrl,
        meta: meta ?? this.meta,
        description: description ?? this.description,
        blurhash: blurhash ?? this.blurhash
      );

  factory AttachmentEntity.fromJson(Map<String, dynamic> json) =>
      _$AttachmentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentEntityToJson(this);
}

@JsonSerializable()
@immutable
class MetaEntity extends Object {

  @JsonKey(name: 'length')
  final String length;

  @JsonKey(name: 'duration')
  final double duration;

  @JsonKey(name: 'fps')
  final int fps;

  @JsonKey(name: 'size')
  final String size;

  @JsonKey(name: 'width')
  final double width;

  @JsonKey(name: 'height')
  final double height;

  @JsonKey(name: 'aspect')
  final double aspect;

  @JsonKey(name: 'audio_encode')
  final String audioEncode;

  @JsonKey(name: 'audio_bitrate')
  final String audioBitrate;

  @JsonKey(name: 'audio_channels')
  final String audioChannels;

  @JsonKey(name: 'original')
  final OriginalEntity original;

  @JsonKey(name: 'small')
  final SmallEntity small;

  @JsonKey(name: 'focus')
  final FocusEntity focus;

  MetaEntity({
    this.length = '',
    this.duration = 0.0,
    this.fps = 0,
    this.size = '',
    this.width = 0.0,
    this.height = 0.0,
    this.aspect = 0.0,
    this.audioEncode = '',
    this.audioBitrate = '',
    this.audioChannels = '',
    this.original,
    this.small,
    this.focus,
  });

  MetaEntity copyWith({
    String length,
    double duration,
    int fps,
    String size,
    double width,
    double height,
    double aspect,
    String audioEncode,
    String audioBitrate,
    String audioChannels,
    OriginalEntity original,
    SmallEntity small,
    FocusEntity focus
  }) =>
      MetaEntity(
        length: length ?? this.length,
        duration: duration ?? this.duration,
        fps: fps ?? this.fps,
        size: size ?? this.size,
        width: width ?? this.width,
        height: height ?? this.height,
        aspect: aspect ?? this.aspect,
        audioEncode: audioEncode ?? this.audioEncode,
        audioBitrate: audioBitrate ?? this.audioBitrate,
        audioChannels: audioChannels ?? this.audioChannels,
        original: original ?? this.original,
        small: small ?? this.small,
        focus: focus ?? this.focus
      );

  factory MetaEntity.fromJson(Map<String, dynamic> json) =>
      _$MetaEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MetaEntityToJson(this);
}

@JsonSerializable()
@immutable
class OriginalEntity extends Object {

  @JsonKey(name: 'width')
  final double width;

  @JsonKey(name: 'height')
  final double height;

  @JsonKey(name: 'size')
  final String size;

  @JsonKey(name: 'aspect')
  final double aspect;

  @JsonKey(name: 'frame_rate')
  final String frameRate;

  @JsonKey(name: 'duration')
  final double duration;

  @JsonKey(name: 'bitrate')
  final int bitrate;


  OriginalEntity({
    this.width = 0.0,
    this.height = 0.0,
    this.size = '',
    this.aspect = 0.0,
    this.frameRate = '',
    this.duration = 0.0,
    this.bitrate = 0,
  });

  OriginalEntity copyWith({
    double width,
    double height,
    String size,
    double aspect,
    String frameRate,
    double duration,
    int bitrate
  }) =>
      OriginalEntity(
        width: width ?? this.width,
        height: height ?? this.height,
        size: size ?? this.size,
        aspect: aspect ?? this.aspect,
        frameRate: frameRate ?? this.frameRate,
        duration: duration ?? this.duration,
        bitrate: bitrate ?? this.bitrate
      );

  factory OriginalEntity.fromJson(Map<String, dynamic> json) =>
      _$OriginalEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OriginalEntityToJson(this);
}

@JsonSerializable()
@immutable
class SmallEntity extends Object {

  @JsonKey(name: 'width')
  final double width;

  @JsonKey(name: 'height')
  final double height;

  @JsonKey(name: 'size')
  final String size;

  @JsonKey(name: 'aspect')
  final double aspect;

  SmallEntity({
    this.width = 0.0,
    this.height = 0.0,
    this.size = '',
    this.aspect = 0.0,
  });

  SmallEntity copyWith({
    double width,
    double height,
    String size,
    double aspect,
  }) =>
      SmallEntity(
        width: width ?? this.width,
        height: height ?? this.height,
        size: size ?? this.size,
        aspect: aspect ?? this.aspect,
      );

  factory SmallEntity.fromJson(Map<String, dynamic> json) =>
      _$SmallEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SmallEntityToJson(this);
}

@JsonSerializable()
@immutable
class FocusEntity extends Object {

  @JsonKey(name: 'x')
  final double x;

  @JsonKey(name: 'y')
  final double y;

  FocusEntity({
    this.x = 0.0,
    this.y = 0.0,
  });

  FocusEntity copyWith({
    double x,
    double y,
  }) =>
      FocusEntity(
        x: x ?? this.x,
        y: y ?? this.y
      );

  factory FocusEntity.fromJson(Map<String, dynamic> json) =>
      _$FocusEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FocusEntityToJson(this);
}