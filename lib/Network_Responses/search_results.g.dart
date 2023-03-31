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

ProfileSearchResult _$ProfileSearchResultFromJson(Map<String, dynamic> json) =>
    ProfileSearchResult(
      json['first_name'] as String,
      json['last_name'] as String,
      json['id'] as int,
    );

Map<String, dynamic> _$ProfileSearchResultToJson(
        ProfileSearchResult instance) =>
    <String, dynamic>{
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'id': instance.id,
    };
