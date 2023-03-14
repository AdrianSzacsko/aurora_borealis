import 'package:flutter/material.dart';

import '../Screens/login_screen.dart';
import 'app_bar.dart';

class NotLoggedInScreen extends StatelessWidget {
  const NotLoggedInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Placeholder(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 16,
                    left: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.no_accounts_outlined,
                            size: 50,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "You are currently not logged in",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FilledButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            ),
                            child: const Text("Log In"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}