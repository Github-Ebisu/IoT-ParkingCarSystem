import 'package:flutter/material.dart';

import 'package:parking_car_app/screens/home/setting_form.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/auth.dart';
import '../../shared/colors.dart';
import '../../shared/constants.dart';
import 'home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 1;
  String _title = "Home";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels?>(context);
    void _showSettingPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingForm(),
            );
          });
    }

    return Scaffold(
      drawer: NavigationDrawer(
        children: [
          Container(
            height: 220,
            child: DrawerHeader(
              child: InkWell(
                onTap: (user!.uid == adminId)
                    ? null
                    : () {
                        setState(() {
                          _title = "Identity";
                          _selectedIndex = 0;
                          Navigator.pop(context); // Then close the drawer
                        });
                      },
                child: Column(
                  children: <Widget>[
                    const CircleAvatar(radius: 38, backgroundImage: AssetImage("assets/avatar.jpeg")),
                    const SizedBox(height: 10),
                    Text("Member", style: textStyle16Light.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Text("${user.email}", style: textStyle16Light.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 72,
            alignment: Alignment.centerLeft,
            child: buildListTile(
              icon: Icons.home_outlined,
              title: 'Home',
              onTap: () {
                // Update the state of the app
                setState(() {
                  _title = "Home";
                  _selectedIndex = 1;
                });
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            height: 72,
            alignment: Alignment.centerLeft,
            child: switch (user.uid) {
              adminId => buildListTile(
                  icon: Icons.account_box_outlined,
                  title: 'Account Management',
                  onTap: () {
                    // Update the state of the app
                    setState(() {
                      _title = "Account Management";
                      _selectedIndex = 2;
                    });
                    // Then close the drawer
                    Navigator.pop(context);
                  }),
              _ => buildListTile(
                  icon: Icons.wallet_outlined,
                  title: 'Wallet',
                  onTap: () {
                    // Update the state of the app
                    setState(() {
                      _title = "Wallet";
                      _selectedIndex = 2;
                    });
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
            },
          ),
          Container(
            height: 72,
            alignment: Alignment.centerLeft,
            child: switch (user.uid) {
              adminId => buildListTile(
                  icon: Icons.car_crash_outlined,
                  title: 'Parking Management',
                  onTap: () {
                    // Update the state of the app
                    setState(() {
                      _title = "Parking Management";
                      _selectedIndex = 3;
                    });
                    // Then close the drawer
                    Navigator.pop(context);
                  }),
              _ => null,
            },
          ),
          Container(
            child: switch (user.uid) {
              adminId => Container(
                  height: 72,
                  alignment: Alignment.centerLeft,
                  child: buildListTile(
                      icon: Icons.add_card_outlined,
                      title: 'RFID',
                      onTap: () {
                        // Update the state of the app
                        setState(() {
                          _title = "Add RFID";
                          _selectedIndex = 4;
                        });
                        // Then close the drawer
                        Navigator.pop(context);
                      }),
                ),
              _ => null,
            },
          ),
          Container(
            child: switch (user.uid) {
              adminId => Container(
                  height: 72,
                  alignment: Alignment.centerLeft,
                  child: buildListTile(
                      icon: Icons.currency_exchange_outlined,
                      title: 'Update',
                      onTap: () {
                        // Update the state of the app
                        setState(() {
                          _title = "Update";
                          _selectedIndex = 5;
                        });
                        // Then close the drawer
                        Navigator.pop(context);
                      }),
                ),
              _ => null,
            },
          ),
          buildDivider(),
          Container(
            height: 72,
            alignment: Alignment.centerLeft,
            child: buildListTile(
              icon: Icons.logout,
              title: 'Log out',
              onTap: () async {
                // Update the state of the app
                _selectedIndex = 3;
                await _authService.signOut();
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(_title, style: textStyle28Light.copyWith(color: PrimaryDarkColor2)),
        backgroundColor: flexThemeDataLight.secondaryHeaderColor,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => _showSettingPanel(),
            icon: const Icon(Icons.settings),
            label: Text("Setting", style: textStyle28Light.copyWith(fontSize: 22, color: PrimaryDarkColor2)),
          ),
        ],
      ),
      body: MyHomePage(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
