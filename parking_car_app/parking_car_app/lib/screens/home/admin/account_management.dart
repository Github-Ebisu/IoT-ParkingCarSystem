import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking_car_app/models/user_account.dart';
import 'package:parking_car_app/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../services/database.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  State<AccountManagement> createState() => _AccountManagementSate();
}

class _AccountManagementSate extends State<AccountManagement> {
  int? sortColumnIndex = 0;
  bool isAscending = false;
  late Future<List<UserAccount>> usersAccountFuture;
  late List<UserAccount> usersAccount;

  Future<void> _handleRefresh() async {
    await CustomRefresh.handleRefresh();
    try {
      List<UserAccount> updatedUserAccountList = await DatabaseService().getListUserAccount;

      setState(() {
        usersAccount.clear();
        usersAccount.addAll(updatedUserAccountList);
      });
      print('Data refreshed successfully!');
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    usersAccountFuture = DatabaseService().getListUserAccount;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModels>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<List<UserAccount>>(
      future: usersAccountFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          usersAccount = snapshot.data!;
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
    final columns = ["Name", "Email", "Reg plate", "RFID", "Money"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 15.0),
        Text("User Account Table", style: textStyle24Light.copyWith(color: flexThemeDataLight.primaryColorLight)),
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
          rows: getRows(usersAccount),
          columnSpacing: 1,
          horizontalMargin: 1,
        ),
      ],
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
          label: Container(
            alignment: Alignment.centerRight,
            width: 65,
            child: Text(column, style: textStyle16Light.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          onSort: onSort))
      .toList();

  List<DataRow> getRows(List<UserAccount> users) => users.map((UserAccount userAccount) {
        final cells = [
          userAccount.userName,
          userAccount.userEmail,
          userAccount.userLicensePlate,
          userAccount.userRFID,
          userAccount.userMoney,
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map(
        (data) => DataCell(
          Container(
            alignment: Alignment.center,
            child: Text('$data', style: textStyle12Light.copyWith(fontSize: 10)),
          ),
        ),
      )
      .toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      usersAccount.sort((user1, user2) => compareString(ascending, user1.userName, user2.userName));
    } else if (columnIndex == 1) {
      usersAccount.sort((user1, user2) => compareString(ascending, user1.userEmail, user2.userEmail));
    } else if (columnIndex == 2) {
      usersAccount.sort((user1, user2) => compareString(ascending, user1.userLicensePlate, user2.userLicensePlate));
    } else if (columnIndex == 3) {
      usersAccount.sort((user1, user2) => compareString(ascending, user1.userRFID, user2.userRFID));
    } else if (columnIndex == 4) {
      usersAccount.sort((user1, user2) => compareString(ascending, "${user1.userMoney}", "${user2.userMoney}"));
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
