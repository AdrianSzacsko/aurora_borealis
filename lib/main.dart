import 'package:aurora_borealis/Components/custom_navigator.dart';
import 'package:aurora_borealis/Screens/menu_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Network/push_notification.dart';
import 'Screens/login_screen.dart';
import 'constants.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);
    if (!(permission == LocationPermission.always || permission == LocationPermission.whileInUse)){
      LocationPermission permission = await Geolocator.requestPermission();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();

    return OverlaySupport.global(child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: primaryColor,
          fontFamily: "Roboto",
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,)
      ),
      home: const MenuScreen(),
    ));
  }
}