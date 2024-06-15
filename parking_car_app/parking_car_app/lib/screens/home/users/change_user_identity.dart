import 'dart:math';

import 'package:flutter/material.dart';

import 'package:parking_car_app/models/user.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';

class ChangeUserIdentity extends StatefulWidget {
  const ChangeUserIdentity({super.key});

  @override
  State<ChangeUserIdentity> createState() {
    return _ChangeUserIdentityState();
  }
}

class _ChangeUserIdentityState extends State<ChangeUserIdentity> {
  int rfid = 0;
  final _formKey = GlobalKey<FormState>();

  // Form values
  String? _currentAvatar;
  String? _currentUserName;
  String? _currentEmail;
  String? _currentPassword;
  String? _currentLicensePlate;

  int? _currentUserNameID;
  int? _currentEmailID;
  int? _currentPasswordID;
  int? _currentLicensePlateID;

  int generateRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(1001); // Số ngẫu nhiên từ 0 đến 1000
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    final AuthService authService = AuthService();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  const Center(child: CircleAvatar(radius: 42, backgroundImage: AssetImage("assets/avatar.jpeg"))),

                  const SizedBox(height: 40.0),

                  //Display user information here
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // User Name
                        Container(
                          width: (screenWidth * 0.8),
                          child: Row(
                            children: [
                              const Icon(Icons.person, size: 38),
                              const SizedBox(width: 8.0),
                              Container(
                                width: 110,
                                child: Text("User Name", style: textStyle16Light.copyWith(fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: TextFormField(
                                  key: ObjectKey(_currentUserNameID),
                                  initialValue: _currentUserName ?? userData.userName,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.isEmpty ? "Please enter user name" : null,
                                  onChanged: (val) => setState(() => _currentUserName = val),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        //Email
                        Container(
                          width: (screenWidth * 0.8),
                          child: Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 38),
                              const SizedBox(width: 8.0),
                              Container(
                                width: 110,
                                child: Text("Email", style: textStyle16Light.copyWith(fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: TextFormField(
                                  key: ObjectKey(_currentEmailID),
                                  initialValue: _currentEmail ?? userData.email,
                                  decoration: textInputDecoration,
                                  validator: (val) => val!.isEmpty ? "Please enter email" : null,
                                  onChanged: (val) => setState(() => _currentEmail = val),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        // Reset Password
                        Container(
                          width: (screenWidth * 0.8),
                          child: Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 38),
                              const SizedBox(width: 8.0),
                              Container(
                                width: 110,
                                child: Text("Password", style: textStyle16Light.copyWith(fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: TextFormField(
                                  key: ObjectKey(_currentPasswordID),
                                  initialValue: _currentPassword ?? userData.password,
                                  decoration: textInputDecoration,
                                  validator: (val) => (val!.length < 6) ? "Enter password with more 6 chars" : null,
                                  obscureText: true,
                                  onChanged: (val) {
                                    setState(() => _currentPassword = val);
                                  },
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20.0),

                        // License Plate
                        Container(
                          width: (screenWidth * 0.8),
                          child: Row(
                            children: [
                              const Icon(Icons.credit_card, size: 38),
                              const SizedBox(width: 8.0),
                              Container(
                                width: 110,
                                child: Text("License plate", style: textStyle16Light.copyWith(fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: TextFormField(
                                  key: ObjectKey(_currentLicensePlateID),
                                  initialValue: _currentLicensePlate ?? userData.licensePlate,
                                  decoration: textInputDecoration,
                                  validator: (val) => (val!.length < 9) ? "Vehicle license plate must be 9 digits or more" : null,
                                  onChanged: (val) => setState(() => _currentLicensePlate = val),
                                  readOnly: (userData.parkingStatus == true) ? true : false,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _currentUserNameID = generateRandomNumber();
                                  _currentEmailID = generateRandomNumber();
                                  _currentPasswordID = generateRandomNumber();
                                  _currentLicensePlateID = generateRandomNumber();

                                  _formKey.currentState?.reset();

                                  _currentEmail = null;
                                  _currentUserName = null;
                                  _currentPassword = null;
                                  _currentLicensePlate = null;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: flexSchemeLight.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                fixedSize: const Size(120, 50),
                              ),
                              child: Text("Cancel", style: textStyle16Light.copyWith(color: flexSchemeLight.surfaceTint)),
                            ),

                            const SizedBox(width: 40.0),

                            // Save
                            OutlinedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await DatabaseService(uid: user.uid).updateUserDataParking(
                                    _currentEmail ?? userData.email,
                                    _currentPassword ?? userData.password,
                                    userData.avatar,
                                    _currentUserName ?? userData.userName,
                                    userData.RFID,
                                    userData.money,
                                    userData.parkingDate,
                                    userData.parkingTime,
                                    userData.parkingStatus,
                                    _currentLicensePlate ?? userData.licensePlate,
                                  );

                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: Text('Notification',
                                          style: textStyle20Light.copyWith(
                                            color: flexSchemeLight.outline,
                                          )),
                                      content: const Text("Your changes have been saved !", style: textStyle16Light),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => {Navigator.pop(context, 'OK')},
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: flexSchemeLight.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                fixedSize: const Size(120, 50),
                              ),
                              child: Text("Save", style: textStyle16Light.copyWith(color: flexSchemeLight.surfaceTint)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  // void showToast(String msg) {
  //   Fluttertoast.showToast(
  //     msg: msg,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM, // You can change the position
  //     timeInSecForIosWeb: 1, // Time duration for iOS
  //     backgroundColor: Colors.grey,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }
}
