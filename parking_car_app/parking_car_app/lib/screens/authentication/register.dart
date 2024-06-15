import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../shared/colors.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text filed state
  String email = "";
  String password = "";
  String confirm_password = "";
  String licensePlate = "";
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
                    widget.toggleView(); // Access the funtion of widget
                  },
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.transparent, side: BorderSide.none),
                  icon: const Icon(Icons.arrow_back_ios_new, color: TooltipColor2),
                ),
                centerTitle: true,
                title: Text(
                  "Sign up",
                  style: textStyle32Light.copyWith(color: TooltipColor2),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background4.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Account
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

                        // Confirm Password
                        TextFormField(
                          validator: (val) => (val != password) ? "Password is not the same" : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => confirm_password = val);
                          },
                          decoration: const InputDecoration(hintText: "Confirm Password"),
                        ),
                        const SizedBox(height: 20.0),

                        // License Plate
                        TextFormField(
                          validator: (val) => (val!.length < 9) ? "Vehicle license plate must be 9 digits or more" : null,
                          onChanged: (val) {
                            setState(() => licensePlate = val);
                          },
                          decoration: const InputDecoration(hintText: "Biển số xe"),
                        ),
                        const SizedBox(height: 20.0),

                        Center(
                          child: OutlinedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _authService.registerWithEmailAndPassword(email, password, licensePlate);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error = "Email or password is invalid !";
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
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
                        ),
                        const SizedBox(height: 12.0),
                        Text(error, style: textStyle16Light.copyWith(color: flexSchemeLight.error)),

                        // Space
                        Container(height: MediaQuery.of(context).size.height - 572),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
