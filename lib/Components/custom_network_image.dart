import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../key.dart';

class CustomNetworkImage extends StatelessWidget{
  final String url;

  const CustomNetworkImage({Key? key, required this.url}) : super(key: key);




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
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 50,);
                  },
                ),
              ),
              radius: 50,
            );
          }
          else if (snapshot.hasError){
            return const CircleAvatar(
              child: Icon(Icons.account_circle),
              radius: 50,
            );
          }
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

}