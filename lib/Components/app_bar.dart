import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../Screens/menu_screen.dart';

AppBar myAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: primaryColor,
    //leading: const Icon(Icons.menu),
    leading: GestureDetector(
      onTap: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          bool? result= await dialogConfirmation(context, "Log Out",
              "Are you sure you want to log out?");
          if (result == true){
            SystemNavigator.pop();
          }
        }
      },
      child: const Icon(
        Icons.arrow_back_outlined, // add custom icons also
      ),
    ),
    actions: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen()));
            },
            child: const Icon(Icons.menu),
          )),
    ],
  );
}

Future<bool> dialogConfirmation(
  BuildContext context,
  String title,
  String content, {
  String textNo = 'No',
  String textYes = 'Yes',
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        title: Text(title, textAlign: TextAlign.center),
        content: Text(content, textAlign: TextAlign.center),
        actions: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    backgroundColor: primaryColor[300],
                    onPressed: () => Navigator.pop(context, true),
                    child: const Icon(
                      Icons.check_outlined,
                      color: Colors.white,
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: secondaryColor[300],
                    onPressed: () => Navigator.pop(context, false),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
