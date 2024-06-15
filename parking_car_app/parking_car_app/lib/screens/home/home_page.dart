import 'package:flutter/material.dart';
import 'package:parking_car_app/screens/home/admin/account_management.dart';
import 'package:parking_car_app/screens/home/users/change_user_identity.dart';

import 'package:parking_car_app/screens/home/admin/parking_management.dart';
import 'package:parking_car_app/screens/home/users/home_user_app.dart';

import 'package:parking_car_app/shared/constants.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import 'admin/home_admin_app.dart';
import 'admin/update_fare_and_carslot.dart';
import 'admin/updating_RFID.dart';
import 'users/wallet.dart';

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.selectedIndex});

  int selectedIndex;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final List<Widget> _widgetUserOptions = <Widget>[
    const ChangeUserIdentity(),
    const UserHomeApp(),
    const Wallet(),
    Loading(),
  ];

  static final List<Widget> _widgetAdminOptions = <Widget>[
    const Placeholder(),
    const AdminHomeApp(),
    const AccountManagement(),
    const ParkingManagement(),
    const UdatingRFID(),
    const UdatingFareAndCarslot(),
    Loading(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    return (user.uid == adminId) ? _widgetAdminOptions[widget.selectedIndex] : _widgetUserOptions[widget.selectedIndex];
  }
}
