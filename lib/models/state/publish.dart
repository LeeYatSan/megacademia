import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'publish.g.dart';

@JsonSerializable()
@immutable
class PublishState {
  final String text;
  final List<String> images;
  final List<String> videos;

  PublishState({
    this.text = '',
    this.images = const [],
    this.videos = const [],
  });

  factory PublishState.fromJson(Map<String, dynamic> json) =>
      _$PublishStateFromJson(json);

  Map<String, dynamic> toJson() => _$PublishStateToJson(this);

  PublishState copyWith({
    String text,
    List<String> images,
    List<String> videos,
  }) =>
      PublishState(
        text: text ?? this.text,
        images: images ?? this.images,
        videos: videos ?? this.videos,
      );
}