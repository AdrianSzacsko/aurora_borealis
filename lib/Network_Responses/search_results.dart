import 'package:aurora_borealis/Network/weather.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_results.g.dart';

class SearchResults{

  SearchResults();

  static Future<List<SearchResult>> search(String search) async {
    List<SearchResult> list = [];
    var response = await WeatherNetwork().getSearch(search);
    if (response.statusCode == 200){
      list = _createList(response.data);
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
