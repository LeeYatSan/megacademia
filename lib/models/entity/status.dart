import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:megacademia/models/entity/attachment.dart';
import 'package:megacademia/models/entity/poll.dart';
import 'package:megacademia/models/entity/user.dart';

import 'tag.dart';
import 'poll.dart';

part 'status.g.dart';

@JsonSerializable()
@immutable
class StatusEntity extends Object{
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'in_reply_to_id')
  final String inReplyToId;

  @JsonKey(name: 'in_reply_to_account_id')
  final String inReplyToAccountId;

  @JsonKey(name: 'sensitive')
  final bool sensitive;

  @JsonKey(name: 'spoiler_text')
  final String spoiler_text;

  @JsonKey(name: 'visibility')
  final String visibility;

  @JsonKey(name: 'language')
  final String language;

  @JsonKey(name: 'uri')
  final String uri;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'replies_count')
  final int repliesCount;

  @JsonKey(name: 'reblogs_count')
  final int reblogsCount;

  @JsonKey(name: 'favourites_count')
  final int favouritesCount;

  @JsonKey(name: 'favourited')
  final bool favourited;

  @JsonKey(name: 'reblogged')
  final bool reblogged;

  @JsonKey(name: 'muted')
  final bool muted;

  @JsonKey(name: 'bookmarked')
  final bool bookmarked;

  @JsonKey(name: 'pinned')
  final bool pinned;

  @JsonKey(name: 'content')
  final String content;

  @JsonKey(name: 'reblog')
  final StatusEntity reblog;

  @JsonKey(name: 'application')
  final ApplicationEntity application;

  @JsonKey(name: 'account')
  final UserEntity account;

  @JsonKey(name: 'media_attachments')
  final List<AttachmentEntity>mediaAttachments;

  @JsonKey(name: 'mentions')
  final List<MentionEntity>mentions;

  @JsonKey(name: 'tags')
  final List<TagEntity>tags;

  @JsonKey(name: 'emojis')
  final List<Emoji>emojis;

  @JsonKey(name: 'card')
  final CardEntity card;

  @JsonKey(name: 'poll')
  final PollEntity poll;

  StatusEntity({
    this.id = '',
    this.createdAt = '',
    this.inReplyToId = '',
    this.inReplyToAccountId = '',
    bool sensitive,
    this.spoiler_text = '',
    this.visibility = '',
    this.language = '',
    this.uri = '',
    this.url = '',
    this.repliesCount = 0,
    this.reblogsCount = 0,
    this.favouritesCount = 0,
    bool favourited,
    bool reblogged,
    bool muted,
    bool bookmarked,
    bool pinned,
    this.content = '',
    this.reblog,
    this.application,
    this.account,
    this.mediaAttachments = const[],
    this.mentions = const[],
    this.tags = const[],
    this.emojis = const[],
    this.card,
    this.poll
  }) :this.sensitive = sensitive ?? false,
      this.favourited = favourited ?? false,
      this.reblogged = reblogged ?? false,
      this.muted = muted ?? false,
      this.bookmarked = bookmarked ?? false,
      this.pinned = pinned ?? false;

  StatusEntity copyWith({
    String id,
    String createdAt,
    String inReplyToId,
    String inReplyToAccountId,
    bool sensitive,
    String spoiler_text,
    String visibility,
    String language,
    String uri,
    String url,
    int repliesCount,
    int reblogsCount,
    int favouritesCount,
    bool favourited,
    bool reblogged,
    bool muted,
    bool bookmarked,
    bool pinned,
    String content,
    StatusEntity reblog,
    ApplicationEntity application,
    UserEntity account,
    List<ApplicationEntity> mediaAttachments,
    List<MentionEntity> mentions,
    List<TagEntity> tags,
    List<Emoji> emojis,
    CardEntity card,
    PollEntity poll
  }) =>
      StatusEntity(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        inReplyToId: inReplyToId ?? this.inReplyToId,
        inReplyToAccountId: inReplyToAccountId ?? this.inReplyToAccountId,
        sensitive: sensitive ?? this.sensitive,
        spoiler_text: spoiler_text ?? this.spoiler_text,
        visibility: visibility ?? this.visibility,
        language: language ?? this.language,
        uri: uri ?? this.uri,
        url: url ?? this.url,
        repliesCount: repliesCount ?? this.repliesCount,
        reblogsCount: reblogsCount ?? this.reblogsCount,
        favouritesCount: favouritesCount ?? this.favouritesCount,
        favourited: favourited ?? this.favourited,
        reblogged: reblogged ?? this.reblogged,
        muted: muted ?? this.muted,
        bookmarked: bookmarked ?? this.bookmarked,
        pinned: pinned ?? this.pinned,
        content: content ?? this.content,
        reblog: reblog ?? this.reblog,
        application: application ?? this.application,
        account: account ?? this.account,
        mediaAttachments: mediaAttachments ?? this.mediaAttachments,
        mentions: mentions ?? this.mentions,
        tags: tags ?? this.tags,
        emojis: emojis ?? this.emojis,
        card: card ?? this.card,
        poll: poll ?? this.poll
      );

  factory StatusEntity.fromJson(Map<String, dynamic> json)=>
      _$StatusEntityFromJson(json);

  Map<String, dynamic> toJson() => _$StatusEntityToJson(this);
}

@JsonSerializable()
@immutable
class ApplicationEntity extends Object{

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'website')
  final String website;

  const ApplicationEntity({
    this.name = '',
    this.website = '',
  });

  ApplicationEntity copyWith({
    String name,
    String website,
  }) =>
      ApplicationEntity(
        name: name ?? this.name,
        website: website ?? this.website
      );

  factory ApplicationEntity.fromJson(Map<String, dynamic> json)=>
      _$ApplicationEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationEntityToJson(this);
}

@JsonSerializable()
@immutable
class MentionEntity extends Object {

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'acct')
  final String acct;

  MentionEntity({
    this.id = '',
    this.username = '',
    this.url = '',
    this.acct = ''
  });

  MentionEntity copyWith({
    String id,
    String username,
    String url,
    String acct
  }) =>
      MentionEntity(
        id: id ?? this.id,
        username: username ?? this.username,
        url: url ?? this.url,
        acct: acct ?? this.acct
      );

  factory MentionEntity.fromJson(Map<String, dynamic> json)=>
      _$MentionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MentionEntityToJson(this);
}

@JsonSerializable()
@immutable
class CardEntity extends Object {

  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'author_name')
  final String authorName;

  @JsonKey(name: 'author_url')
  final String authorUrl;

  @JsonKey(name: 'provider_name')
  final String providerName;

  @JsonKey(name: 'provider_url')
  final String providerUrl;

  @JsonKey(name: 'html')
  final String html;

  @JsonKey(name: 'width')
  final int width;

  @JsonKey(name: 'height')
  final int height;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'embed_url')
  final String embedUrl;

  CardEntity({
    this.url = '',
    this.title = '',
    this.description = '',
    this.type = '',
    this.authorName = '',
    this.authorUrl = '',
    this.providerName = '',
    this.providerUrl = '',
    this.html = '',
    this.width = 0,
    this.height = 0,
    this.image = '',
    this.embedUrl = ''
  });

  CardEntity copyWith({
    String url,
    String title,
    String description,
    String type,
    String authorName,
    String authorUrl,
    String providerName,
    String providerUrl,
    String html,
    int width,
    int height,
    String image,
    String embedUrl,
  }) =>
      CardEntity(
        url: url ?? this.url,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        authorName: authorName ?? this.authorName,
        authorUrl: authorUrl ?? this.authorUrl,
        providerName: providerName ?? this.providerName,
        providerUrl: providerUrl ?? this.providerUrl,
        html: html ?? this.html,
        width: width ?? this.width,
        height: height ?? this.height,
        image: image ?? this.image,
        embedUrl: embedUrl ?? this.embedUrl
      );

  factory CardEntity.fromJson(Map<String, dynamic> json)=>
      _$CardEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CardEntityToJson(this);
}