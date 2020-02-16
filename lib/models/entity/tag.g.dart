// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagEntity _$TagEntityFromJson(Map<String, dynamic> json) {
  return TagEntity(
    name: json['name'] as String,
    url: json['url'] as String,
    history: (json['history'] as List)
        ?.map((e) => e == null
            ? null
            : HistoryEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TagEntityToJson(TagEntity instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'history': instance.history,
    };

HistoryEntity _$HistoryEntityFromJson(Map<String, dynamic> json) {
  return HistoryEntity(
    day: json['day'] as String,
    uses: json['uses'] as String,
    accounts: json['accounts'] as String,
  );
}

Map<String, dynamic> _$HistoryEntityToJson(HistoryEntity instance) =>
    <String, dynamic>{
      'day': instance.day,
      'uses': instance.uses,
      'accounts': instance.accounts,
    };
