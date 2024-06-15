import 'package:flutter/material.dart';
import 'package:parking_car_app/shared/colors.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pink, width: 1.0)),
);

const textStyle12Light = TextStyle(
  fontSize: 12,
  color: Color(0xff090909),
  fontFamily: "Times New Roman",
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.w300,
);

const textStyle16Light = TextStyle(
  fontSize: 16,
  color: Color(0xff090909),
  fontFamily: "Times New Roman",
  fontWeight: FontWeight.normal,
  letterSpacing: 0.15,
  height: 1.5,
);

const textStyle20Light = TextStyle(
  fontSize: 20,
  color: Color(0xff090909),
  fontFamily: "Times New Roman",
  fontWeight: FontWeight.w600,
);

const textStyle24Light = TextStyle(
  fontSize: 24,
  color: Color(0xff090909),
  fontFamily: "Times New Roman",
  fontWeight: FontWeight.bold,
  letterSpacing: 0.00,
  height: 1.33,
);

const textStyle28Light = TextStyle(
  fontSize: 28,
  color: Color(0xff090909),
  fontFamily: "Times New Roman",
  fontWeight: FontWeight.bold,
  letterSpacing: 0.00,
  height: 1.29,
);

const textStyle32Light = TextStyle(
  fontSize: 32,
  color: Color(0xff090909),
  fontFamily: "Times New Roman",
  fontWeight: FontWeight.bold,
  letterSpacing: 0.00,
  height: 1.25,
);

Widget buildListTile({required IconData icon, required String title, required Function onTap}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () => onTap(),
  );
}

Widget buildDivider() {
  return const Divider(
    color: Colors.black38,
  );
}

// Switch(
//   value: updatingRFIDEnable,
//   onChanged: (value) {
//     setState(() {
//       updatingRFIDEnable = value;
//     });
//   },
//   activeColor: flexSchemeLight.background, // Color when switch is on
//   activeTrackColor: flexThemeDataLight.secondaryHeaderColor, // Color of the strip when the switch is on
//   activeThumbImage: const AssetImage("assets/icon_winter.png"), // The image will display on the button when the Switch is on.
//   inactiveThumbColor: flexThemeDataLight.secondaryHeaderColor, // Color of the button when the switch is off
//   inactiveTrackColor: flexSchemeLight.onPrimary, // Color of the strip when the switch is off
//   inactiveThumbImage: const AssetImage("assets/snowman.png"),
//   trackOutlineColor: MaterialStateProperty.resolveWith<Color>(
//     (Set<MaterialState> states) {
//       if (states.contains(MaterialState.disabled)) {
//         // Color of the border when the Switch is off
//         return flexThemeDataLight.secondaryHeaderColor;
//       }
//       return flexThemeDataLight.secondaryHeaderColor;
//     },
//   ),
// ),

const adminId = "UubQplMKWDSdTiNhuYpONLh6cnk2";
const double widthCheckCard = 99;
const double heightCheckCard = 50;
