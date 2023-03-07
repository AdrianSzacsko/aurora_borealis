// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
      json['display_name'] as String,
      json['type'] as String,
      (json['lat'] as num).toDouble(),
      (json['lon'] as num).toDouble(),
      (json['importance'] as num).toDouble(),
    );

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'display_name': instance.display_name,
      'type': instance.type,
      'lat': instance.lat,
      'lon': instance.lon,
      'importance': instance.importance,
    };
