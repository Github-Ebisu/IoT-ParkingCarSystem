import 'package:flutter/material.dart';
import 'package:parking_car_app/models/admin.dart';
import 'package:parking_car_app/models/user.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';

class AdminHomeApp extends StatefulWidget {
  const AdminHomeApp({super.key});

  @override
  State<AdminHomeApp> createState() {
    return _AdminHomeAppState();
  }
}

class _AdminHomeAppState extends State<AdminHomeApp> {
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
            onRefresh: _AdminHomeAppState._handleRefresh,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Admin Information
                  Container(
                    margin: EdgeInsets.all(25.0),
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

                  // Tình trạng gửi xe
                  Container(
                    margin: const EdgeInsets.all(25.0),
                    width: screenWidth,
                    height: screenHeight / 4,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Tình trạng gửi xe", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${adminData.carPassengerCount}/${adminData.carSlot}", style: textStyle20Light),
                              const SizedBox(width: 10.0),
                              Icon(Icons.motorcycle, size: (52), color: flexThemeDataLight.primaryColorLight),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Doanh thu trong ngày
                  Container(
                    margin: const EdgeInsets.all(25.0),
                    width: screenWidth,
                    height: screenHeight / 4,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Doanh thu trong ngày", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                          const SizedBox(height: 5.0),
                          Text("${adminData.revenue}", style: textStyle20Light),
                          const SizedBox(height: 5.0),
                          const Text("VND", style: textStyle20Light),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
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
}
