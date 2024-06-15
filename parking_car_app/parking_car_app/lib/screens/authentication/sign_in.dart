import 'package:flutter/material.dart';
import 'package:parking_car_app/screens/authentication/reset_password.dart';
import 'package:parking_car_app/shared/colors.dart';

import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() {
    return _SingInState();
  }
}

class _SingInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text filed state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: flexThemeDataLight.secondaryHeaderColor,
              elevation: 0.0,
              title: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Sign in", style: textStyle32Light.copyWith(color: TooltipColor2)),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background7.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 110.0),
                      // Email
                      TextFormField(
                        validator: (val) => (val!.isEmpty) ? "Enter email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        decoration: const InputDecoration(hintText: "Email"),
                      ),

                      const SizedBox(height: 20.0),

                      // Password
                      TextFormField(
                        validator: (val) => (val!.length < 6) ? "Enter password with more 6 chars" : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        decoration: const InputDecoration(hintText: "Password"),
                      ),
                      const SizedBox(height: 20.0),

                      // Forgot password
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ResetPassword(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot password ?",
                            style: textStyle16Light.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Sign in
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = "Email or password is invalid !";
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          fixedSize: const Size(120, 50),
                        ),
                        child: const Text("Log in"),
                      ),

                      const SizedBox(height: 12.0),

                      // Error
                      Text(error, style: textStyle16Light.copyWith(color: flexSchemeLight.error)),

                      // Icon google, facebook, Microsoft

                      // Space

                      Container(height: MediaQuery.of(context).size.height - 532),

                      // Sign up
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Don't have an account yet ?",
                            style: textStyle12Light.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF23355B),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color(0xFF3B5998),
                                ),
                                const SizedBox(width: 4),
                                Text("Sign Up", style: textStyle12Light.copyWith(color: const Color(0xFF23314D))),
                              ],
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 12.0),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
