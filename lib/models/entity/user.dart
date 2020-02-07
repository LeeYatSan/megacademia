import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserEntity extends Object{

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'acct')
  String acct;

  @JsonKey(name: 'display_name')
  String displayName;

  @JsonKey(name: 'locked')
  bool locked;

  @JsonKey(name: 'bot')
  bool bot;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'note')
  String note;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'avatar')
  String avatar;

  @JsonKey(name: 'avatar_static')
  String avatarStatic;

  @JsonKey(name: 'header')
  String header;

  @JsonKey(name: 'header_static')
  String headerStatic;

  @JsonKey(name: 'followers_count')
  int followersCount;

  @JsonKey(name: 'following_count')
  int followingCount;

  @JsonKey(name: 'statuses_count')
  int statusesCount;

  @JsonKey(name: 'last_status_at')
  String lastStatusAt;

  @JsonKey(name: 'source')
  Source source;

  @JsonKey(name: 'emojis')
  List<dynamic> emojis;

  @JsonKey(name: 'fields')
  List<dynamic> fields;

  UserEntity({
    this.id = '',
    this.username = '',
    this.acct = '',
    this.displayName = '',
    this.locked = false,
    this.bot = false,
    this.createdAt = '',
    this.note = '',
    this.url = '',
    this.avatar = 'images/missing.png',
    this.avatarStatic = 'images/missing.png',
    this.header = 'images/login.png',
    this.headerStatic = 'images/login.png',
    this.followersCount = 0,
    this.followingCount = 0,
    this.statusesCount = 0,
    this.lastStatusAt = '',
  });
//  UserEntity(this.id,this.username,this.acct,this.displayName,this.locked,this.bot,this.createdAt,this.note,this.url,this.avatar,this.avatarStatic,this.header,this.headerStatic,this.followersCount,this.followingCount,this.statusesCount,this.source,this.emojis,this.fields,);


  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

@JsonSerializable()
class Source extends Object{

  @JsonKey(name: 'privacy')
  String privacy;

  @JsonKey(name: 'sensitive')
  bool sensitive;

  @JsonKey(name: 'language')
  String language;

  @JsonKey(name: 'note')
  String note;

  @JsonKey(name: 'fields')
  List<dynamic> fields;

  @JsonKey(name: 'follow_requests_count')
  int followRequestsCount;

  Source({
    this.privacy = 'public',
    this.sensitive = false,
    this.language = '',
    this.note = '',
    this.followRequestsCount =  0
  });
//  Source(this.privacy,this.sensitive,this.note,this.fields,);

  factory Source.fromJson(Map<String, dynamic> json) =>
      _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}

@JsonSerializable()
class Field extends Object{

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'value')
  final String value;

  @JsonKey(name: 'verified_at')
  final String verifiedAt;

  Field({
    this.name = '',
    this.value = '',
    this.verifiedAt = ''
  });
//  Field(this.name,this.value,this.verifiedAt);

  factory Field.fromJson(Map<String, dynamic> json) =>
      _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}

@JsonSerializable()
class Emoji extends Object{

  @JsonKey(name: 'shortcode')
  final String shortcode;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'static_url')
  final String staticUrl;

  @JsonKey(name: 'visible_in_picker')
  final bool visibleInPicker;

  Emoji({
    this.shortcode = '',
    this.url = '',
    this.staticUrl = '',
    this.visibleInPicker = true
  });
//  Emoji(this.shortcode,this.url,this.staticUrl,this.visibleInPicker,);

  factory Emoji.fromJson(Map<String, dynamic> json) =>
      _$EmojiFromJson(json);

  Map<String, dynamic> toJson() => _$EmojiToJson(this);
}