import 'package:flutter/material.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Stack(
        fit: StackFit.expand,
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
                      topLeft: Radius.circular(40))),
              child: Padding(
                  padding: const EdgeInsets.only(top: 50, right: 16, left: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 28
                          ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CustomFormField(
                                controller: emailController,
                                hintText: 'Enter Email',
                                labelText: 'Email',
                                validator: (value) {
                                  if (value!.isValidEmail && value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Enter valid Email';
                                  }
                                },
                                prefixIcon: Icons.email_outlined,
                                isPassword: false),
                            CustomFormField(
                                controller: passwordController,
                                hintText: 'Enter Password',
                                labelText: 'Password',
                                validator: (value) {
                                  if (value!.isValidPassword && value.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Enter valid Password';
                                  }
                                },
                                prefixIcon: Icons.password_outlined,
                                isPassword: true),
                            //loginForm('Enter Email', 'Email', 'Wrong email', Icons.email_outlined, false),
                            //loginForm('Enter Password', 'Password', 'Wrong password', Icons.password_outlined, false, isPassword: true),
                            FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print(emailController.text + " " + passwordController.text);
                                  //change screen
                                }
                                else {

                                }
                              },
                              child: const Text('Sign In'),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an Account?',
                              style: TextStyle(
                                  fontSize: 14
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                  fontSize: 14
                              )),
                                onPressed: null,
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 14
                                  ),
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loginForm(String hintText, String labelText, String errorText,
      IconData icon, bool wrong,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          errorText: !wrong ? null : 'Bad email',
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
          suffixIcon: !wrong
              ? null
              : const Icon(
                  Icons.error,
                ),
        ),
      ),
    );
  }
}
