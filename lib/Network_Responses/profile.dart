import 'package:aurora_borealis/Network/profile.dart';
import 'package:aurora_borealis/Network_Responses/farms.dart';


class Profile{
  late bool init;
  final int id;
  late String first_name;
  late String last_name;
  late int post_count;
  late int like_count;
  late int dislike_count;
  late List<Farms> farms;
  late bool is_like;
  late String picture_path;

  Profile._create(this.id){
    farms = [];
    picture_path = "";
  }

  static Future<Profile> create(int id) async {
    var component = Profile._create(id);

    var response = await ProfileNetwork().getProfile(id);

    if (response.statusCode == 200){
      component.fromJson(response.data);
      component.init = true;
    }
    else {
      component.init = false;
    }

    return component;
  }

  fromJson(Map<String, dynamic> json){
    first_name = json['first_name'];
    last_name = json['last_name'];
    post_count = json['post_count'];
    like_count = json['like_count'];
    dislike_count = json['dislike_count'];
    if (json['farms'] != null){
      for (int i = 0; i < json['farms'].length; i++){
        farms.add(Farms.fromJson(json['farms'][i]));
      }
    }
    if (json['is_like'] != null){
      is_like = json['is_like'];
    }
    if (json['picture_path'] != null){
      picture_path = json['picture_path'];
    }
  }
}

