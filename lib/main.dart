import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/login_screen.dart';
import 'constants.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
            colorSchemeSeed: primaryColor,
            fontFamily: "Roboto",
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme,)
        ),
        home: const LoginScreen(),
      );
  }
}