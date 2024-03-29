import 'package:aurora_borealis/Network/profile.dart';
import 'package:aurora_borealis/Network/weather.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Components/snackbar.dart';
import '../Screens/menu_screen.dart';

part 'search_results.g.dart';

class SearchResults{

  SearchResults();

  static Future<List<SearchResult>> search(String search, context) async {
    List<SearchResult> list = [];
    var response = await WeatherNetwork().getSearch(search);

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
    }

    if (response.statusCode == 200){
      list = _createList(response.data);
    }
    else if (response.statusCode == 401){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }), (r){
        return false;
      });
    }
    else{
      errorResponseBar("Something went wrong", context);
    }

    return list;
  }

  static List<SearchResult> _createList(dynamic data){
    List<SearchResult> list = [];
    for (int i = 0; i < data.length; i++){
      list.add(SearchResult.fromJson(data[i]));
    }
    return list;
  }


}

class ProfileSearchResults{

  ProfileSearchResults();

  static Future<List<ProfileSearchResult>> search(String search, context) async {
    List<ProfileSearchResult> list = [];
    var response = await ProfileNetwork().getSearch(search);

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
    }

    if (response.statusCode == 200){
      list = _createList(response.data);
    }
    else if (response.statusCode == 401){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }), (r){
        return false;
      });
    }
    else{
      errorResponseBar("Something went wrong", context);
    }

    return list;
  }

  static List<ProfileSearchResult> _createList(dynamic data){
    List<ProfileSearchResult> list = [];
    for (int i = 0; i < data.length; i++){
      list.add(ProfileSearchResult.fromJson(data[i]));
    }
    return list;
  }


}

@JsonSerializable()
class SearchResult{
  final String display_name;
  final String type;
  final double lat;
  final double lon;
  final double importance;

  SearchResult(this.display_name, this.type, this.lat, this.lon,
      this.importance);

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

@JsonSerializable()
class ProfileSearchResult{
  final String first_name;
  final String last_name;
  final int id;


  ProfileSearchResult(this.first_name, this.last_name, this.id);

  factory ProfileSearchResult.fromJson(Map<String, dynamic> json) => _$ProfileSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileSearchResultToJson(this);
}
