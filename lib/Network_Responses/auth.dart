import 'package:aurora_borealis/Components/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Network/auth.dart';
import '../Screens/login_screen.dart';
import '../Screens/menu_screen.dart';

class Auth {

  static login(String email, String password, context) async {
    Response? response = await AuthNetwork().login(email, password);

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
      return;
    }

    if (response.statusCode == 200){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }), (r){
        return false;
      });
      /*Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen(),
          settings: RouteSettings(arguments: shared.getInt('user_id'))));*/
    }
    else {
      errorResponseBar("Something went wrong", context);
    }
  }

  static register(String email, String firstName, String lastName, String password, context) async {
    Response? response = await AuthNetwork().register(email, firstName, lastName, password);

    if (response == null){
      errorResponseBar("Connection Error", context);
      return;
    }

    if (response.statusCode == 201){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
    else {
      errorResponseBar("Something went wrong", context);
    }
  }
}