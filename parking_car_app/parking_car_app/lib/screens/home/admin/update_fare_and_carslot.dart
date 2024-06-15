import 'package:flutter/material.dart';
import 'package:parking_car_app/models/admin.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../shared/loading.dart';

class UdatingFareAndCarslot extends StatefulWidget {
  const UdatingFareAndCarslot({Key? key}) : super(key: key);

  @override
  State<UdatingFareAndCarslot> createState() {
    return _UdatingFareAndCarslotState();
  }
}

class _UdatingFareAndCarslotState extends State<UdatingFareAndCarslot> {
  final _formKey = GlobalKey<FormState>();
  bool updatingRFIDEnable = false;
  // text filed state
  String currentFee = "";
  String currentCarSlot = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    return StreamBuilder<AdminData>(
      stream: DatabaseService(uid: user.uid).adminData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AdminData adminData = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Information", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                    const SizedBox(height: 15.0),
                    Text("Current parking fees : ${adminData.parkingFee}", style: textStyle16Light.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 7.0),
                    Text("Current parking space : ${adminData.carSlot}", style: textStyle16Light.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30.0),

                    Text("Update", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                    const SizedBox(height: 10.0),
                    // Parking Fee
                    TextFormField(
                      validator: (val) => (val!.isEmpty) ? "Enter new Fee parking" : null,
                      onChanged: (val) {
                        setState(() => currentFee = val);
                      },
                      decoration: const InputDecoration(hintText: "Parking Fee"),
                    ),
                    const SizedBox(height: 20.0),

                    // Car Slot
                    TextFormField(
                      validator: (val) => (val!.isEmpty) ? "Enter new Car slot" : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => currentCarSlot = val);
                      },
                      decoration: const InputDecoration(hintText: "Car slot"),
                    ),
                    const SizedBox(height: 20.0),

                    Center(
                      child: OutlinedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              DatabaseService(uid: user.uid).updateAdminField("carSlot", int.parse(currentCarSlot));
                              DatabaseService(uid: user.uid).updateAdminField("parkingFee", int.parse(currentFee));
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) => AlertDialog(
                                  title: const Text('Thông báo', style: textStyle24Light),
                                  content: const Text('Updating successfully', style: textStyle16Light),
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
        } else {
          return Loading();
        }
      },
    );
  }
}
