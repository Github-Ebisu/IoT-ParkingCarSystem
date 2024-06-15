import 'package:flutter/material.dart';
import 'package:parking_car_app/models/admin.dart';
import 'package:parking_car_app/models/user.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() {
    return _AdminHomeState();
  }
}

class _AdminHomeState extends State<AdminHome> {
  int rfid = 0;
  static Future<void> _handleRefresh() async {
    await CustomRefresh.handleRefresh();
  }

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
            return CustomRefresh(
              onRefresh: _AdminHomeState._handleRefresh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 30, backgroundImage: AssetImage("assets/avatar.jpeg")),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          children: [
                            Text("Admin", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                            const SizedBox(height: 5.0),
                            Text(adminData.email, style: textStyle12Light.copyWith(fontSize: 14, fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // User Information
                  Container(
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
                              Text("Tình trạng gửi xe", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                              const SizedBox(height: 10.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StreamBuilder<int>(
                                    stream: DatabaseService(uid: user.uid).countDocumentsWithParkingStatusStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        int count = snapshot.data!;
                                        return Text("$count/${adminData.carSlot}", style: textStyle20Light);
                                      } else if (snapshot.hasError) {
                                        return Text("Error: ${snapshot.error}");
                                      } else {
                                        return const CircularProgressIndicator(); // Or other loading indicator
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 10.0),
                                  Icon(Icons.motorcycle, size: (52), color: flexSchemeLight.primary),
                                ],
                              ),
                            ],
                          ),
                          const VerticalDivider(color: Colors.black, thickness: 0.5, width: 0.0),
                          // Column right card
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text("Doanh thu trong ngày", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                              const SizedBox(height: 5.0),
                              Text("${adminData.revenue}", style: textStyle20Light),
                              const SizedBox(
                                height: 5.0,
                              ),
                              const Text("VND", style: textStyle20Light),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
