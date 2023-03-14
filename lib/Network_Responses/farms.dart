import 'package:aurora_borealis/Network/farm.dart';
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


class FarmsList{
  List<Farms> farms = [];

  FarmsList._create();

  static Future<FarmsList> create() async {
    var component = FarmsList._create();

    var response = await FarmNetwork().getFarms();

    if (response.statusCode == 200){
      component.fromJson(response.data);
    }

    return component;
  }

  fromJson(List<dynamic> json){
    farms.clear();
    for (int i = 0; i < json.length; i++){
      farms.add(Farms.fromJson(json[i]));
    }
  }
}