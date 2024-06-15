import 'package:flutter/material.dart';
import 'package:parking_car_app/screens/home/admin/waiting_update_RFID.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';

class UdatingRFID extends StatefulWidget {
  const UdatingRFID({super.key});

  @override
  State<UdatingRFID> createState() {
    return _UdatingRFIDState();
  }
}

class _UdatingRFIDState extends State<UdatingRFID> {
  final _formKey = GlobalKey<FormState>();
  bool updatingRFIDEnable = false;
  // text filed state
  String email = "";
  String password = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),

              // Account
              TextFormField(
                validator: (val) => (val!.isEmpty) ? "Enter email" : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
                decoration: const InputDecoration(hintText: "Email"),
              ),
              const SizedBox(height: 20.0),

              Center(
                child: OutlinedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        updatingRFIDEnable = true;
                      });
                      Map<String, dynamic> fieldsToUpdate = {
                        "emailUser": email,
                        "updatingStatus": updatingRFIDEnable,
                      };
                      bool emailExists = await DatabaseService().checkEmailDocumentUserExist(email);
                      if (!emailExists) {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) => AlertDialog(
                            title: const Text('Notification', style: textStyle24Light),
                            content: const Text('Email does not exist', style: textStyle16Light),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, 'OK');
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        try {
                          DatabaseService(uid: user.uid).updateAdminField("updateRFIDStatus", fieldsToUpdate);
                          if (updatingRFIDEnable == false) {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) => AlertDialog(
                                title: const Text('Notification', style: textStyle24Light),
                                content: const Text('Successfully updated status does not allow adding RFID card !', style: textStyle16Light),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext, 'OK');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const WaitingUpdate(),
                              ),
                            );
                          }
                        } catch (e) {
                          print("Error updating: $e");
                          showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text('Error!', style: textStyle24Light),
                                  content: Text(e.toString(), style: textStyle16Light),
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
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: flexSchemeLight.primary),
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
            ],
          ),
        ),
      ),
    );
  }
}
