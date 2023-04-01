import 'package:aurora_borealis/Network/profile.dart';
import 'package:aurora_borealis/Network_Responses/farms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Components/snackbar.dart';
import '../Screens/menu_screen.dart';


class Profile{
  late bool init;
  final int id;
  late String first_name;
  late String last_name;
  late int post_count;
  late int like_count;
  late List<Farms> farms;
  late bool interaction;
  late String picture_path;

  Profile._create(this.id){
    farms = [];
    picture_path = "";
  }

  static Future<Profile> create(int id, context) async {
    var component = Profile._create(id);

    var response = await ProfileNetwork().getProfile(id);

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
    }

    if (response.statusCode == 200){
      component.fromJson(response.data);
      component.init = true;
    }
    else if (response.statusCode == 401){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }), (r){
        return false;
      });
    }
    else{
      component.init = false;
      errorResponseBar("Something went wrong", context);
    }

    return component;
  }

  fromJson(Map<String, dynamic> json){
    first_name = json['first_name'];
    last_name = json['last_name'];
    post_count = json['post_count'];
    like_count = json['like_count'];
    if (json['farms'] != null){
      for (int i = 0; i < json['farms'].length; i++){
        farms.add(Farms.fromJson(json['farms'][i]));
      }
    }
    if (json['interaction'] != null){
      interaction = json['interaction'];
    }
    else{
      interaction = false;
    }
    if (json['picture_path'] != null){
      picture_path = json['picture_path'];
    }
  }

  static likeOrDislike(int profileId, bool status, BuildContext context) async {
    Response? response = await ProfileNetwork().likeOrDislike(profileId, status);

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
      return;
    }

    if (response.statusCode == 200){
      //everything is good

      /*Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen(),
          settings: RouteSettings(arguments: shared.getInt('user_id'))));*/
    }
    else {
      errorResponseBar("Something went wrong", context);
    }
  }

  static Future<void> deleteAccount(context) async {
    Response? response = await ProfileNetwork().deleteAccount();

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
      return;
    }

    if (response.statusCode == 200){
      successResponseBar("Account deleted successfully", context);
      return;
    }
    else {
      errorResponseBar("Something went wrong", context);
    }
  }
}

