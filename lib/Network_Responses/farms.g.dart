// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Farms _$FarmsFromJson(Map<String, dynamic> json) => Farms(
      json['id'] as int,
      json['name'] as String,
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$FarmsToJson(Farms instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
