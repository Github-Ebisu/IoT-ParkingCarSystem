import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/admin.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../shared/loading.dart';

class WaitingUpdate extends StatefulWidget {
  const WaitingUpdate({Key? key}) : super(key: key);

  @override
  State<WaitingUpdate> createState() {
    return _WaitingUpdateState();
  }
}

class _WaitingUpdateState extends State<WaitingUpdate> {
  bool _isCardScanned = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<AdminData>(
      stream: DatabaseService(uid: user.uid).adminData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AdminData adminData = snapshot.data!;
          if (!adminData.updatingStatus && _isCardScanned == true) {
            Future.delayed(Duration.zero, () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) => AlertDialog(
                  title: const Text('Notification', style: textStyle24Light),
                  content: const Text('Scanning card successfully!', style: textStyle16Light),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ).then((value) => Navigator.pop(context));
            });
          }
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Waiting for RFID card scanning",
                      style: textStyle28Light.copyWith(color: PrimaryDarkColor2),
                    ),
                    const SizedBox(height: 20.0),
                    CustomSpinkit2,
                    const SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {
                        try {
                          _isCardScanned = false;
                          DatabaseService(uid: user.uid).updateAdminField("updateRFIDStatus.updatingStatus", false);
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
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: flexSchemeLight.onPrimary,
                        side: BorderSide(
                          color: flexSchemeLight.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        fixedSize: const Size(150, 50),
                      ),
                      child: Text("Cancel", style: textStyle16Light.copyWith(color: flexSchemeLight.surfaceTint)),
                    ),
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
