import 'package:flutter/material.dart';
import 'package:parking_car_app/models/user.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../shared/price_check_.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() {
    return _WalletState();
  }
}

class _WalletState extends State<Wallet> {
  int rfid = 0;
  bool isChecked = false;

  // text filed state
  int money = 0;
  String error = "";
  int? selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void setCheck(int? value, int money) {
      if (selectedValue == value) {
        selectedValue = 0;
        this.money = 0;
      } else {
        selectedValue = value;
        this.money = money;
      }
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Row(
                    children: [
                      Image.asset("assets/icon_card.png", height: 52, width: 52, fit: BoxFit.scaleDown),
                      const SizedBox(width: 15.0),
                      Text("Chọn mệnh giá", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
                    ],
                  ),
                ),

                // User Information
                Container(
                  margin: const EdgeInsets.all(20.0),
                  height: screenHeight / 3,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Độ cong của góc
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            PriceCheckbox(
                              width: widthCheckCard,
                              height: heightCheckCard,
                              iconSize: 20.0,
                              label: "10.000",
                              value: 1,
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  setCheck(value, 10000);
                                });
                              },
                              isChecked: false,
                            ),
                            const SizedBox(width: 8.0),
                            PriceCheckbox(
                              width: widthCheckCard,
                              height: heightCheckCard,
                              iconSize: 20.0,
                              label: '20.000',
                              value: 2,
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  setCheck(value, 20000);
                                });
                              },
                              isChecked: false,
                            ),
                            const SizedBox(width: 8.0),
                            PriceCheckbox(
                              width: widthCheckCard,
                              height: heightCheckCard,
                              iconSize: 20.0,
                              label: '50.000',
                              value: 3,
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  setCheck(value, 50000);
                                });
                              },
                              isChecked: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            PriceCheckbox(
                              width: widthCheckCard,
                              height: heightCheckCard,
                              iconSize: 20.0,
                              label: '100.000',
                              value: 4,
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  setCheck(value, 100000);
                                });
                              },
                              isChecked: false,
                            ),
                            const SizedBox(width: 8.0),
                            PriceCheckbox(
                              width: widthCheckCard,
                              height: heightCheckCard,
                              iconSize: 20.0,
                              label: '200.000',
                              value: 5,
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  setCheck(value, 200000);
                                });
                              },
                              isChecked: false,
                            ),
                            const SizedBox(width: 8.0),
                            PriceCheckbox(
                              width: widthCheckCard,
                              height: heightCheckCard,
                              iconSize: 20.0,
                              label: '500.000',
                              value: 6,
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  setCheck(value, 500000);
                                });
                              },
                              isChecked: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset("assets/recharge_card.png", width: 500.0, height: 200.0, fit: BoxFit.contain),
                      Positioned(
                        bottom: 16.0,
                        child: Text(
                          "${money}",
                          style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30.0),

                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: flexSchemeLight.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      fixedSize: const Size(200, 50),
                    ),
                    onPressed: () async {
                      int money = 0;
                      setState(() {
                        money = userData.money + this.money;
                      });
                      if (this.money == 0) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Thông báo nạp tiền',
                                style: textStyle20Light.copyWith(
                                  color: flexSchemeLight.outline,
                                )),
                            content: const Text("Bạn chưa chọn mệnh giá nạp tiền !", style: textStyle16Light),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => {Navigator.pop(context, 'OK')},
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Thông báo nạp tiền',
                                style: textStyle20Light.copyWith(
                                  color: flexSchemeLight.outline,
                                )),
                            content: Text("Bạn có xác nhận nạp ${this.money} ?", style: textStyle16Light),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => {Navigator.pop(context, 'Cancel')},
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await DatabaseService(uid: user.uid).updateUserDataParking(
                                    userData.email,
                                    userData.password,
                                    userData.avatar,
                                    userData.userName,
                                    userData.RFID,
                                    money,
                                    userData.parkingDate,
                                    userData.parkingTime,
                                    userData.parkingStatus,
                                    userData.licensePlate,
                                  );
                                  setState(() {
                                    this.money = 0;
                                    selectedValue = 0;
                                    Navigator.pop(context, 'OK');
                                  });
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text("Nạp tiền", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
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
