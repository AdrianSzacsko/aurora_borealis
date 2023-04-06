import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Network/profile.dart';
import 'package:aurora_borealis/Screens/menu_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Components/not_logged_in.dart';
import '../Network_Responses/auth.dart';
import '../Network_Responses/profile.dart';
import '../Network_Responses/settings.dart';
import 'register_screen.dart';
import '../Components/app_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:aurora_borealis/Network/auth.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

enum SwitchType {
  weather,
  news
}

class SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null) {
      return const NotLoggedInScreen();
    }

    return Scaffold(
      appBar: myAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset('assets/images/backgroundGreen.jpg',
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,),
          ),
          FutureBuilder(
            future: Future.microtask(() => Settings.create(context)),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData){

              Settings data = snapshot.data;
              return settingsScreen(data);
            }
            else{
              return const Center(child: CircularProgressIndicator(),);
            }
          })
        ],
      ),
    );
  }

  Future<void> changeNotifications(bool weather, bool news) async {
    await Settings.setValues(weather, news, context);
    setState(() {

    });
  }

  Widget settingsScreen(Settings data){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40))),
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    createSwitch("Weather Notifications", data, changeNotifications, SwitchType.weather),
                    createSwitch("News Notifications", data, changeNotifications, SwitchType.news),
                    const SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: FilledButton(
                                  onPressed: () async {
                                    bool? result = await dialogConfirmation(
                                        context, "Delete Account", "Are you sure you want to delete account?");
                                    if (result == true) {
                                      SharedPreferences cache = await SharedPreferences.getInstance();
                                      await Profile.deleteAccount(context);
                                      await cache.remove("user_id");
                                      await cache.remove("token");
                                      SystemNavigator.pop();
                                    }
                                  },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.no_accounts_outlined),
                                  SizedBox(width: 5,),
                                  Text("Delete Account")
                                ],
                              )
                          )),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.03,),
                          Expanded(child: FilledButton(
                              onPressed: () async {
                                bool? result = await dialogConfirmation(
                                    context, "Log Out", "Are you sure you want to Log Out?");
                                if (result == true) {
                                  /*SharedPreferences cache = await SharedPreferences.getInstance();
                                  await cache.remove("user_id");
                                  await cache.remove("token");
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                                    return const MenuScreen();
                                  }), (r){
                                    return false;
                                  });
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                                    return const MenuScreen();
                                  }));*/
                                  await Settings.logout(context);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.logout_outlined),
                                  SizedBox(width: 5,),
                                  Text("Log Out")
                                ],
                              )
                          ),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16,)
                  ],
                )
            ),
          )
      ),
    );
  }


  Widget createSwitch(String text, Settings data, Future<void> Function(bool weather, bool news) change, SwitchType switchType){
    late bool switchValue;
    switch (switchType) {
      case SwitchType.weather:
        switchValue = data.weather_notifications;
        break;
      case SwitchType.news:
        switchValue = data.news_notifications;
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 20),),
          Switch(
              value: switchValue,
              onChanged: (value){
                switch (switchType) {
                  case SwitchType.weather:
                    change(value, data.news_notifications);
                    break;
                  case SwitchType.news:
                    change(data.weather_notifications, value);
                    break;
                }
              }
          )
        ],
      ),
    );
  }
}


