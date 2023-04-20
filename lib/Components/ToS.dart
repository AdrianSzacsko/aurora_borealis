
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future showToS(BuildContext context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        title: const Text("Terms of Use", textAlign: TextAlign.center),
        content: FutureBuilder(
          future: rootBundle.loadString("assets/text/terms_of_use.txt"),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData){
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Text(snapshot.data),
                )
              );
            }
            else{
              return const Center(child: CircularProgressIndicator());
            }
          },

        ),
    );
  });
}