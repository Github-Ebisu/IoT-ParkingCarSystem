import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking_car_app/models/user_parking.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';

class ParkingManagement extends StatefulWidget {
  const ParkingManagement({super.key});

  @override
  State<ParkingManagement> createState() => _ParkingManagementSate();
}

class _ParkingManagementSate extends State<ParkingManagement> {
  int? sortColumnIndex = 0;
  bool isAscending = false;
  late Future<List<UserParking>> usersParkingFuture;
  late List<UserParking> usersParking;

  Future<void> _handleRefresh() async {
    await CustomRefresh.handleRefresh();
    try {
      List<UserParking> updatedUserParkingList = await DatabaseService().getListUserParking;

      setState(() {
        // Cập nhật dữ liệu mới vào danh sách
        usersParking.clear(); // Xóa dữ liệu cũ
        usersParking.addAll(updatedUserParkingList); // Thêm dữ liệu mới
      });
      print('Data refreshed successfully!');
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Bắt đầu tải dữ liệu khi widget được tạo
    usersParkingFuture = DatabaseService().getListUserParking;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<UserParking>>(
      future: usersParkingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          usersParking = snapshot.data!;
          return CustomRefresh(
            onRefresh: _handleRefresh,
            child: Container(
              alignment: Alignment.topCenter,
              width: screenWidth,
              height: screenHeight - 75,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: buildDataTable(),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildDataTable() {
    final columns = ["Name", "Status", "Time", "Date"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 15.0),
        Text("Car Parking Board", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
        const SizedBox(height: 15.0),
        DataTable(
          headingRowColor: MaterialStateProperty.all(flexThemeDataLight.secondaryHeaderColor),
          dataRowColor: MaterialStateProperty.all(flexSchemeLight.surfaceVariant),
          dividerThickness: 1.2,
          decoration: BoxDecoration(
            border: Border.all(color: flexSchemeLight.primary),
          ),
          showBottomBorder: true,
          sortAscending: isAscending,
          sortColumnIndex: sortColumnIndex,
          columns: getColumns(columns),
          rows: getRows(usersParking),
          columnSpacing: 1,
          horizontalMargin: 5,
        ),
      ],
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
          label: Container(
            alignment: Alignment.centerRight,
            width: 70,
            child: Text(column, style: textStyle16Light.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          onSort: onSort))
      .toList();

  List<DataRow> getRows(List<UserParking> users) => users.map((UserParking userParking) {
        final cells = [userParking.userName, "parking", userParking.parkingTime, userParking.parkingDate];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map(
        (data) => DataCell(
          Container(
            alignment: Alignment.center,
            child: Text('$data', style: textStyle12Light),
          ),
        ),
      )
      .toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      usersParking.sort((user1, user2) => compareString(ascending, user1.userName, user2.userName));
    } else if (columnIndex == 1) {
      usersParking.sort((user1, user2) => compareString(ascending, "parking", "parking"));
    } else if (columnIndex == 2) {
      usersParking.sort((user1, user2) => compareString(ascending, user1.parkingTime, user2.parkingTime));
    } else if (columnIndex == 3) {
      usersParking.sort((user1, user2) => compareString(ascending, user1.parkingDate, user2.parkingDate));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) {
    if (value1 == value2) return 0;
    return ascending ? value1.compareTo(value2) : value2.compareTo(value1);
  }
}
