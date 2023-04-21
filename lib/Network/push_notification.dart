import 'dart:io';

import 'package:aurora_borealis/Network_Responses/settings.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise() async {
    /*if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }*/

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await _fcm.getToken();
    //print("FirebaseMessaging token: $token");
    if (token != null){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('fcm_token', token);
      await Settings.setFCM(token);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //print("onMessage: ${message.data}");
      showSimpleNotification(
        Text(message.notification?.title ?? 'Unknown'),
        leading: const Icon(Icons.info_outline),
        subtitle: Text(message.notification?.body ?? 'Unknown'),
        background: primaryColor,
        duration: const Duration(seconds: 4),
      );

    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onOpenedAppMessage: $message");
    });
    //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    /*_fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );*/
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}