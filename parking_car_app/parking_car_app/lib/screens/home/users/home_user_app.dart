import 'package:flutter/material.dart';
import 'package:parking_car_app/models/user.dart';
import 'package:parking_car_app/shared/colors.dart';
import 'package:parking_car_app/shared/constants.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../../services/database.dart';

class UserHomeApp extends StatefulWidget {
  const UserHomeApp({super.key});

  @override
  State<UserHomeApp> createState() {
    return _UserHomeAppState();
  }
}

class _UserHomeAppState extends State<UserHomeApp> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data!;
            List<bool> _isCheckState = [!userData.parkingStatus, userData.parkingStatus];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // User Information
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(25.0),
                  height: screenHeight / 3,
                  child: Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Column left card
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const CircleAvatar(radius: 42, backgroundImage: AssetImage("assets/avatar.jpeg")),
                            const SizedBox(height: 8.0),
                            Text(
                              userData.userName,
                              style: textStyle16Light.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 5.0),
                            Text("${userData.email}", style: textStyle12Light)
                            // Column left card
                          ],
                        ),

                        // Column right card
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            // Switch
                            Icon(Icons.wallet, size: (60), color: flexSchemeLight.primary),
                            const SizedBox(height: 5.0),

                            Text("${userData.money}", style: textStyle20Light),
                            const SizedBox(height: 5.0),

                            const Text("VND", style: textStyle20Light)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  alignment: Alignment.center,
                  child: Text("Thông tin gửi xe ", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                ),

                // Parking Information
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.fromLTRB(25, 12, 25, 12),
                  height: screenHeight / 3,
                  child: Card(
                    child: Container(
                      margin: EdgeInsets.only(left: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("License plate : ${userData.licensePlate}", style: textStyle16Light.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 15),
                          Text("RFID : ${userData.RFID}", style: textStyle16Light.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 15),
                          Text(
                            (userData.parkingStatus == true) ? "Date sent : ${userData.parkingDate}" : "Date picked up : ${userData.parkingDate}",
                            style: textStyle16Light.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 15),
                          Text("Time : ${userData.parkingTime}", style: textStyle16Light.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 15),
                          Row(
                            children: <Widget>[
                              Text("Status: ", style: textStyle16Light.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(width: 12),
                              ToggleButtons(
                                  selectedBorderColor: flexSchemeLight.primary,
                                  borderColor: flexSchemeLight.primary,
                                  borderRadius: BorderRadius.circular(12.0),
                                  onPressed: (value) {},
                                  isSelected: _isCheckState,
                                  children: [
                                    Container(
                                      alignment: AlignmentDirectional.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      width: 100,
                                      child: const Text(
                                        "Đã lấy xe",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Times New Roman",
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: AlignmentDirectional.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      width: 100,
                                      child: const Text(
                                        "Đang gửi",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Times New Roman",
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Loading();
          }
        });
  }
}
