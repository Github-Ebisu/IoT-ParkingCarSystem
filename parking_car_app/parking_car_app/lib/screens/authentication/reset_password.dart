import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../shared/colors.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text filed state
  String email = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Loading()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: flexThemeDataLight.secondaryHeaderColor,
                elevation: 0.0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Access the funtion of widget
                  },
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.transparent, side: BorderSide.none),
                  icon: Icon(Icons.arrow_back_ios_new, color: TooltipColor2),
                ),
                centerTitle: true,
                title: Text(
                  "Reset Password",
                  style: textStyle32Light.copyWith(color: TooltipColor2),
                ),
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background5.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) => (val!.isEmpty) ? "Enter email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        decoration: const InputDecoration(hintText: "Email"),
                      ),
                      const SizedBox(height: 20.0),
                      OutlinedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _authService.resetPassword(email);
                            print("Reset Password Result: $result");

                            if (result != true) {
                              setState(() {
                                error = "Email is invalid !";
                              });
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Error!', style: textStyle24Light),
                                      content: Text(result.message.toString(), style: textStyle16Light),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => {
                                            Navigator.pop(dialogContext, 'OK'),
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              await showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) => AlertDialog(
                                  title: const Text('Thông báo', style: textStyle24Light),
                                  content: const Text('Please check your enail !', style: textStyle16Light),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => {
                                        Navigator.pop(dialogContext, 'OK'),
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                          ;
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: flexSchemeLight.onPrimary,
                          side: BorderSide(
                            color: flexSchemeLight.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          fixedSize: const Size(150, 50),
                        ),
                        child: Text("Xác nhận", style: textStyle16Light.copyWith(color: flexSchemeLight.surfaceTint)),
                      ),
                      const SizedBox(height: 12.0),
                      Text(error, style: textStyle16Light.copyWith(color: flexSchemeLight.error)),
                      const SizedBox(height: 12.0),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
