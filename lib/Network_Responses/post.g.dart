// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      json['id'] as int,
      json['user_id'] as int,
      json['first_name'] as String,
      json['last_name'] as String,
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      json['category'] as String,
      json['text'] as String,
      DateTime.parse(json['date'] as String),
      (json['photos_id'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'category': instance.category,
      'text': instance.text,
      'date': instance.date.toIso8601String(),
      'photos_id': instance.photos_id,
    };
