// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return UserEntity(
    id: json['id'] as String,
    username: json['username'] as String,
    acct: json['acct'] as String,
    displayName: json['display_name'] as String,
    locked: json['locked'] as bool,
    bot: json['bot'] as bool,
    createdAt: json['created_at'] as String,
    note: json['note'] as String,
    url: json['url'] as String,
    avatar: json['avatar'] as String,
    avatarStatic: json['avatar_static'] as String,
    header: json['header'] as String,
    headerStatic: json['header_static'] as String,
    followersCount: json['followers_count'] as int,
    followingCount: json['following_count'] as int,
    statusesCount: json['statuses_count'] as int,
    lastStatusAt: json['last_status_at'] as String,
    source: json['source'] == null
        ? null
        : Source.fromJson(json['source'] as Map<String, dynamic>),
    emojis: json['emojis'] as List,
    fields: json['fields'] as List,
  );
}

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'acct': instance.acct,
      'display_name': instance.displayName,
      'locked': instance.locked,
      'bot': instance.bot,
      'created_at': instance.createdAt,
      'note': instance.note,
      'url': instance.url,
      'avatar': instance.avatar,
      'avatar_static': instance.avatarStatic,
      'header': instance.header,
      'header_static': instance.headerStatic,
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'statuses_count': instance.statusesCount,
      'last_status_at': instance.lastStatusAt,
      'source': instance.source,
      'emojis': instance.emojis,
      'fields': instance.fields,
    };

Source _$SourceFromJson(Map<String, dynamic> json) {
  return Source(
    privacy: json['privacy'] as String,
    sensitive: json['sensitive'] as bool,
    language: json['language'] as String,
    note: json['note'] as String,
    fields: json['fields'] as List,
    followRequestsCount: json['follow_requests_count'] as int,
  );
}

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
      'privacy': instance.privacy,
      'sensitive': instance.sensitive,
      'language': instance.language,
      'note': instance.note,
      'fields': instance.fields,
      'follow_requests_count': instance.followRequestsCount,
    };

Field _$FieldFromJson(Map<String, dynamic> json) {
  return Field(
    name: json['name'] as String,
    value: json['value'] as String,
    verifiedAt: json['verified_at'] as String,
  );
}

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'verified_at': instance.verifiedAt,
    };

Emoji _$EmojiFromJson(Map<String, dynamic> json) {
  return Emoji(
    shortcode: json['shortcode'] as String,
    url: json['url'] as String,
    staticUrl: json['static_url'] as String,
    visibleInPicker: json['visible_in_picker'] as bool,
  );
}

Map<String, dynamic> _$EmojiToJson(Emoji instance) => <String, dynamic>{
      'shortcode': instance.shortcode,
      'url': instance.url,
      'static_url': instance.staticUrl,
      'visible_in_picker': instance.visibleInPicker,
    };
