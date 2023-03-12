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
              backgroundImage: NetworkImage(
                url,
                headers: {'authorization': 'Bearer ' + snapshot.data.getString('token') ?? ''},
              ),
              radius: 50,
            );
          }
          else if (snapshot.hasError){
            return const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
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