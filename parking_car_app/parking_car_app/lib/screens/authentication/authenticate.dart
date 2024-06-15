import 'package:flutter/material.dart';
import 'package:parking_car_app/screens/authentication/register.dart';
import 'package:parking_car_app/screens/authentication/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => (showSignIn = !showSignIn));
  }

  @override
  Widget build(BuildContext context) {
    return (showSignIn) ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView);
  }
}
