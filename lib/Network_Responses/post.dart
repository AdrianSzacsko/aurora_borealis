import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post{
  //final double farm_lat;
  //final double farm_lon;
  final int id;
  final int user_id;
  final String first_name;
  final String last_name;
  final double latitude;
  final double longitude;
  final String category;
  final String text;
  final DateTime date;
  List<int> photos_id;


  Post(this.id, this.user_id, this.first_name, this.last_name, this.latitude,
      this.longitude, this.category, this.text, this.date, this.photos_id);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}