// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      (json['coord_lat'] as num).toDouble(),
      (json['coord_lon'] as num).toDouble(),
      json['timezone'] as int,
      json['name'] as String,
      json['sys_country'] as String,
      json['sys_sunset'] as int,
      json['sys_sunrise'] as int,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'coord_lat': instance.coord_lat,
      'coord_lon': instance.coord_lon,
      'timezone': instance.timezone,
      'name': instance.name,
      'sys_country': instance.sys_country,
      'sys_sunset': instance.sys_sunset,
      'sys_sunrise': instance.sys_sunrise,
    };

WeatherVariables _$WeatherVariablesFromJson(Map<String, dynamic> json) =>
    WeatherVariables(
      json['weather_main'] as String,
      json['weather_icon'] as String,
      (json['main_temp'] as num).toDouble(),
      (json['main_temp_max'] as num).toDouble(),
      (json['main_temp_min'] as num).toDouble(),
      (json['main_feels_like'] as num).toDouble(),
      json['main_pressure'] as int,
      json['main_humidity'] as int,
      json['main_sea_level'] as int,
      json['main_grnd_level'] as int,
      json['visibility'] as int,
      (json['wind_speed'] as num).toDouble(),
      json['wind_deg'] as int,
      (json['wind_gust'] as num).toDouble(),
      (json['clouds_all'] as num).toDouble(),
      (json['rain_1h'] as num).toDouble(),
      (json['snow_1h'] as num).toDouble(),
      (json['pop'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherVariablesToJson(WeatherVariables instance) =>
    <String, dynamic>{
      'weather_main': instance.weather_main,
      'weather_icon': instance.weather_icon,
      'main_temp': instance.main_temp,
      'main_temp_max': instance.main_temp_max,
      'main_temp_min': instance.main_temp_min,
      'main_feels_like': instance.main_feels_like,
      'main_pressure': instance.main_pressure,
      'main_humidity': instance.main_humidity,
      'main_sea_level': instance.main_sea_level,
      'main_grnd_level': instance.main_grnd_level,
      'visibility': instance.visibility,
      'wind_speed': instance.wind_speed,
      'wind_deg': instance.wind_deg,
      'wind_gust': instance.wind_gust,
      'clouds_all': instance.clouds_all,
      'rain_1h': instance.rain_1h,
      'snow_1h': instance.snow_1h,
      'pop': instance.pop,
    };
