import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@immutable
@JsonSerializable()
class UserEntity extends Object{

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'acct')
  final String acct;

  @JsonKey(name: 'display_name')
  final String displayName;

  @JsonKey(name: 'locked')
  final bool locked;

  @JsonKey(name: 'bot')
  final bool bot;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'note')
  final String note;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'avatar')
  final String avatar;

  @JsonKey(name: 'avatar_static')
  final String avatarStatic;

  @JsonKey(name: 'header')
  final String header;

  @JsonKey(name: 'header_static')
  final String headerStatic;

  @JsonKey(name: 'followers_count')
  final int followersCount;

  @JsonKey(name: 'following_count')
  final int followingCount;

  @JsonKey(name: 'statuses_count')
  final int statusesCount;

  @JsonKey(name: 'last_status_at')
  final String lastStatusAt;

  @JsonKey(name: 'source')
  final Source source;

  @JsonKey(name: 'emojis')
  final List<dynamic> emojis;

  @JsonKey(name: 'fields')
  final List<dynamic> fields;

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
    Source source,
    this.emojis = const[],
    this.fields = const[],
  }) : this.source =  source;

  UserEntity copyWith({
    String id,
    String username,
    String acct,
    String displayName,
    bool locked,
    bool bot,
    String createdAt,
    String note,
    String url,
    String avatar,
    String avatarStatic,
    String header,
    String headerStatic,
    String followersCount,
    String followingCount,
    String statusesCount,
    String lastStatusAt,
    Source source,
    List<dynamic> emojis,
    List<dynamic> fields
  }) =>
      UserEntity(
        id: id ?? this.id,
        username: username ?? this.username,
        acct: acct ?? this.acct,
        displayName: displayName ?? this.displayName,
        locked: locked ?? this.locked,
        bot: bot ?? this.bot,
        createdAt: createdAt ?? this.createdAt,
        note: note ?? this.note,
        url: url ?? this.url,
        avatar: avatar ?? this.avatar,
        avatarStatic: avatarStatic ?? this.avatarStatic,
        header: header ?? this.header,
        headerStatic: headerStatic ?? this.headerStatic,
        followersCount: followersCount ?? this.followersCount,
        followingCount: followingCount ?? this.followingCount,
        lastStatusAt: lastStatusAt ?? this.lastStatusAt,
        source: source ?? this.source,
        emojis: emojis ?? this.emojis,
        fields: fields ?? this.fields,
      );

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

@immutable
@JsonSerializable()
class Source extends Object{

  @JsonKey(name: 'privacy')
  final String privacy;

  @JsonKey(name: 'sensitive')
  final bool sensitive;

  @JsonKey(name: 'language')
  final String language;

  @JsonKey(name: 'note')
  final String note;

  @JsonKey(name: 'fields')
  final List<dynamic> fields;

  @JsonKey(name: 'follow_requests_count')
  final int followRequestsCount;

  Source({
    this.privacy = 'public',
    this.sensitive = false,
    this.language = '',
    this.note = '',
    this.fields = const [],
    this.followRequestsCount =  0
  });

  Source copyWith({
    String privacy,
    bool sensitive,
    String language,
    String note,
    List<dynamic> fields,
    int followRequestsCount,
  }) =>
      Source(
        privacy: privacy ?? this.privacy,
        sensitive: sensitive ?? this.sensitive,
        language: language?? this.language,
        note: note ?? this.note,
        fields: fields ?? this.fields,
        followRequestsCount: followRequestsCount ?? this.followRequestsCount,
      );

  factory Source.fromJson(Map<String, dynamic> json) =>
      _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}

@immutable
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

  Field copyWith({
    String name,
    String value,
    String verifiedAt,
  }) =>
      Field(
        name: name ?? this.name,
        value: value?? this.value,
        verifiedAt: verifiedAt ?? this.verifiedAt,
      );

  factory Field.fromJson(Map<String, dynamic> json) =>
      _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}

@immutable
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

  Emoji copyWith({
    String shortcode,
    String url,
    String staticUrl,
    bool visibleInPicker
  }) =>
      Emoji(
        shortcode: shortcode ?? this.shortcode,
        url: url ?? this.url,
        staticUrl: staticUrl?? this.staticUrl,
        visibleInPicker: visibleInPicker ?? this.visibleInPicker,
      );

  factory Emoji.fromJson(Map<String, dynamic> json) =>
      _$EmojiFromJson(json);

  Map<String, dynamic> toJson() => _$EmojiToJson(this);
}



@JsonSerializable()
@immutable
class UserListEntity {
  @JsonKey(name: '')
  final List<UserEntity> users;

  const UserListEntity({
    this.users = const[]
  });

  factory UserListEntity.fromJson(Map<String, dynamic> json)=>
      _$UserListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserListEntityToJson(this);
}