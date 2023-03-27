import 'package:aurora_borealis/Network/feed.dart';
import 'package:aurora_borealis/Network/profile.dart';
import 'package:aurora_borealis/Network_Responses/farms.dart';
import 'package:aurora_borealis/Network_Responses/post.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Components/snackbar.dart';
import '../Screens/menu_screen.dart';


class Feed{
  final double latitude;
  final double longitude;
  final int distance;
  late List<Post> posts;

  Feed._create(this.latitude, this.longitude, this.distance);

  static Future<Feed> create(double latitude, double longitude, int distance, context) async {
    var component = Feed._create(latitude, longitude, distance);

    var response = await FeedNetwork().getFeed(latitude, longitude, distance);

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
    }

    if (response.statusCode == 200){
      component.createPosts(response.data);

    }
    else if (response.statusCode == 404){
      component.posts = [];
      errorResponseBar("Feed is empty", context);
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

    return component;
  }

  void createPosts(var data){
    posts = [];
    for (int i = 0; i < data.length; i++){
      posts.add(Post.fromJson(data[i]));
    }
  }


  static newPost(double latitude, double longitude, String category, String text, List<XFile> images, context) async {
    Response? response = await FeedNetwork().newPost(latitude, longitude, category, text);

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
      return;
    }

    if (response.statusCode == 200){

      if (images.isNotEmpty) {
        int postId = response.data['post_id'] as int;
        print(postId);
        await _newPostImages(postId, images, context);
      }
      return;
      /*Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen(),
          settings: RouteSettings(arguments: shared.getInt('user_id'))));*/
    }
    else {
      errorResponseBar("Something went wrong", context);
    }
  }

  static Future<int> _newPostImages(int postId, List<XFile> images, context) async {
    Response? response = await FeedNetwork().postPostPic(postId, images);

    if (response == null){
      errorResponseBar("Connection Error", context);
      return 0;
    }

    if (response.statusCode == 200){
      return 200;
    }
    else {
      errorResponseBar("Imgaes failed to upload", context);
      return 1;
    }
  }
}

