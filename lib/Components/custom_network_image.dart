import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../key.dart';

class CustomNetworkImage extends StatelessWidget{
  final String url;
  double? radius = 50;

  CustomNetworkImage({Key? key, required this.url, this.radius}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  '$url?${DateTime.now().millisecondsSinceEpoch.toString()}',
                  headers: {'authorization': 'Bearer ' + snapshot.data.getString('token')},
                  width: radius! * 2,
                  height: radius! * 2,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, size: radius,);
                  },
                  loadingBuilder: (context, child, loadingProgress){
                    if(loadingProgress == null) {
                      return child;
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              radius: radius,
            );
          }
          else if (snapshot.hasError){
            return CircleAvatar(
              child: const Icon(Icons.account_circle),
              radius: radius! / 2,
            );
          }
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

}

class CustomNetworkPostImage extends StatelessWidget{
  final String url;

  const CustomNetworkPostImage({Key? key, required this.url}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Image.network(
              url,
              headers: {'authorization': 'Bearer ' + snapshot.data.getString('token')},
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 50,);
              },
              loadingBuilder: (context, child, loadingProgress){
                if(loadingProgress == null) {
                  return child;
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          /*else if (snapshot.hasError){
            return CircleAvatar(
              child: const Icon(Icons.account_circle),
            );
          }*/
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

}