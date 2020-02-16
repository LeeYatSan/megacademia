// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusEntity _$StatusEntityFromJson(Map<String, dynamic> json) {
  return StatusEntity(
    id: json['id'] as String,
    createdAt: json['created_at'] as String,
    inReplyToId: json['in_reply_to_id'] as String,
    inReplyToAccountId: json['in_reply_to_account_id'] as String,
    sensitive: json['sensitive'] as bool,
    spoiler_text: json['spoiler_text'] as String,
    visibility: json['visibility'] as String,
    language: json['language'] as String,
    uri: json['uri'] as String,
    url: json['url'] as String,
    repliesCount: json['replies_count'] as int,
    reblogsCount: json['reblogs_count'] as int,
    favouritesCount: json['favourites_count'] as int,
    favourited: json['favourited'] as bool,
    reblogged: json['reblogged'] as bool,
    muted: json['muted'] as bool,
    bookmarked: json['bookmarked'] as bool,
    pinned: json['pinned'] as bool,
    content: json['content'] as String,
    reblog: json['reblog'] == null
        ? null
        : StatusEntity.fromJson(json['reblog'] as Map<String, dynamic>),
    application: json['application'] == null
        ? null
        : ApplicationEntity.fromJson(
            json['application'] as Map<String, dynamic>),
    account: json['account'] == null
        ? null
        : UserEntity.fromJson(json['account'] as Map<String, dynamic>),
    mediaAttachments: (json['media_attachments'] as List)
        ?.map((e) => e == null
            ? null
            : AttachmentEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    mentions: (json['mentions'] as List)
        ?.map((e) => e == null
            ? null
            : MentionEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    tags: (json['tags'] as List)
        ?.map((e) =>
            e == null ? null : TagEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    emojis: (json['emojis'] as List)
        ?.map(
            (e) => e == null ? null : Emoji.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    card: json['card'] == null
        ? null
        : CardEntity.fromJson(json['card'] as Map<String, dynamic>),
    poll: json['poll'] == null
        ? null
        : PollEntity.fromJson(json['poll'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StatusEntityToJson(StatusEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'in_reply_to_id': instance.inReplyToId,
      'in_reply_to_account_id': instance.inReplyToAccountId,
      'sensitive': instance.sensitive,
      'spoiler_text': instance.spoiler_text,
      'visibility': instance.visibility,
      'language': instance.language,
      'uri': instance.uri,
      'url': instance.url,
      'replies_count': instance.repliesCount,
      'reblogs_count': instance.reblogsCount,
      'favourites_count': instance.favouritesCount,
      'favourited': instance.favourited,
      'reblogged': instance.reblogged,
      'muted': instance.muted,
      'bookmarked': instance.bookmarked,
      'pinned': instance.pinned,
      'content': instance.content,
      'reblog': instance.reblog,
      'application': instance.application,
      'account': instance.account,
      'media_attachments': instance.mediaAttachments,
      'mentions': instance.mentions,
      'tags': instance.tags,
      'emojis': instance.emojis,
      'card': instance.card,
      'poll': instance.poll,
    };

ApplicationEntity _$ApplicationEntityFromJson(Map<String, dynamic> json) {
  return ApplicationEntity(
    name: json['name'] as String,
    website: json['website'] as String,
  );
}

Map<String, dynamic> _$ApplicationEntityToJson(ApplicationEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'website': instance.website,
    };

MentionEntity _$MentionEntityFromJson(Map<String, dynamic> json) {
  return MentionEntity(
    id: json['id'] as String,
    username: json['username'] as String,
    url: json['url'] as String,
    acct: json['acct'] as String,
  );
}

Map<String, dynamic> _$MentionEntityToJson(MentionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'url': instance.url,
      'acct': instance.acct,
    };

CardEntity _$CardEntityFromJson(Map<String, dynamic> json) {
  return CardEntity(
    url: json['url'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
    authorName: json['author_name'] as String,
    authorUrl: json['author_url'] as String,
    providerName: json['provider_name'] as String,
    providerUrl: json['provider_url'] as String,
    html: json['html'] as String,
    width: json['width'] as int,
    height: json['height'] as int,
    image: json['image'] as String,
    embedUrl: json['embed_url'] as String,
  );
}

Map<String, dynamic> _$CardEntityToJson(CardEntity instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'author_name': instance.authorName,
      'author_url': instance.authorUrl,
      'provider_name': instance.providerName,
      'provider_url': instance.providerUrl,
      'html': instance.html,
      'width': instance.width,
      'height': instance.height,
      'image': instance.image,
      'embed_url': instance.embedUrl,
    };
