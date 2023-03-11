import 'package:json_annotation/json_annotation.dart';

part 'farms.g.dart';

@JsonSerializable()
class Farms{
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  Farms(this.id, this.name, this.latitude, this.longitude);


  factory Farms.fromJson(Map<String, dynamic> json) => _$FarmsFromJson(json);
  Map<String, dynamic> toJson() => _$FarmsToJson(this);
}