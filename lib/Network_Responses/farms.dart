import 'package:aurora_borealis/Network/farm.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Components/snackbar.dart';
import '../Screens/menu_screen.dart';

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

  static Future<FarmsList> create(context, bool checkLogin) async {
    var component = FarmsList._create();

    var response = await FarmNetwork().getFarms();

    if (response == null){
      errorResponseBar("Connection Error", context);
      return component;
    }

    if (response.statusCode == 200){
      component.fromJson(response.data);
    }
    else if (response.statusCode == 401){
      if (checkLogin){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          return const MenuScreen();
        }), (r){
          return false;
        });
      }
    }
    else{
      errorResponseBar("Something went wrong", context);
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