import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parking_car_app/models/admin.dart';
import 'package:parking_car_app/models/user_account.dart';

import '../models/user_parking.dart';
import '../models/user.dart';

class DatabaseService {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("Users");
  final CollectionReference adminCollection = FirebaseFirestore.instance.collection("Admin");
  final String uid;

  DatabaseService({this.uid = ""});

  Future updateUserDataParking(
    String email,
    String password,
    String avatar,
    String userName,
    String RFID,
    int money,
    String parkingDate,
    String parkingTime,
    bool parkingStatus,
    String licensePlate,
  ) async {
    return await userCollection.doc(uid).set({
      "email": email,
      "password": password,
      "avatar": avatar,
      "userName": userName,
      "RFID": RFID,
      "money": money,
      "parkingDate": parkingDate,
      "parkingTime": parkingTime,
      "parkingStatus": parkingStatus,
      "licensePlate": licensePlate,
    });
  }

  Future updateAdminField(String field, dynamic value) async {
    return await adminCollection.doc(uid).update({field: value});
  }

  // User parking list from Snapshot
  List<UserParking> _userParkingListFromSnapshot(QuerySnapshot querySnapshot) {
    try {
      // Create a list to store information about UserParkings whose parkingStatus is true
      List<UserParking> userParkingList = [];

      // Iterate through all documents
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Check if the parking Status of that document is true
        if (document.get("parkingStatus") == true) {
          // Add User Parking information to the list
          userParkingList.add(UserParking(
            userName: document.get("userName") ?? "",
            parkingStatus: (document.get("parkingStatus") == null) ? "" : document.get("parkingStatus"),
            parkingTime: document.get("parkingTime") ?? "",
            parkingDate: document.get("parkingDate") ?? "",
          ));
        }
      }

      // Returns a list of User Parking and parking Status values that are true
      return userParkingList;
    } catch (e) {
      print(e.toString());
      return []; // Returns an empty list if an error occurs
    }
  }

// Get List user parking doc Stream
  Future<List<UserParking>> get getListUserParking async {
    final snapshot = await userCollection.get();
    final userParkingList = _userParkingListFromSnapshot(snapshot);
    return userParkingList;
  }

  // User Account list from Snapshot
  List<UserAccount> _userAccountListFromSnapshot(QuerySnapshot querySnapshot) {
    try {
      // Create a list to store information about UserAccount whose parkingStatus is true
      List<UserAccount> userAccountList = [];

      // Iterate through all documents
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        // Add User Account information to the list
        userAccountList.add(UserAccount(
          userName: document.get("userName") ?? "",
          userEmail: document.get("email") ?? "",
          userLicensePlate: document.get("licensePlate") ?? "",
          userRFID: document.get("RFID") ?? "",
          userMoney: document.get("money" ?? 0),
        ));
      }
      return userAccountList;
    } catch (e) {
      print(e.toString());
      return []; // Returns an empty list if an error occurs
    }
  }

// Get List users account doc Stream
  Future<List<UserAccount>> get getListUserAccount async {
    final snapshot = await userCollection.get();
    final userAccountList = _userAccountListFromSnapshot(snapshot);
    return userAccountList;
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      email: snapshot.get("email"),
      password: snapshot.get("password"),
      avatar: snapshot.get("avatar"),
      userName: snapshot.get("userName"),
      RFID: snapshot.get("RFID"),
      money: snapshot.get("money"),
      parkingDate: snapshot.get("parkingDate"),
      parkingTime: snapshot.get("parkingTime"),
      parkingStatus: snapshot.get("parkingStatus"),
      licensePlate: snapshot.get("licensePlate"),
    );
  }

  // Get UserData doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // adminData from snapshot
  AdminData _adminDataFromSnapshot(DocumentSnapshot snapshot) {
    return AdminData(
      uid: uid,
      email: snapshot.get("email"),
      password: snapshot.get("password"),
      avatar: snapshot.get("avatar"),
      adminName: snapshot.get("adminName"),
      parkingFee: snapshot.get("parkingFee"),
      carSlot: snapshot.get("carSlot"),
      revenue: snapshot.get("revenue"),
      updatingStatus: snapshot.get("updateRFIDStatus.updatingStatus") ?? false,
      carPassengerCount: snapshot.get("carPassengerCount"),
    );
  }

  // Get AdminData doc stream
  Stream<AdminData> get adminData {
    return adminCollection.doc(uid).snapshots().map(_adminDataFromSnapshot);
  }

  StreamController<int> _countController = StreamController<int>();

  Stream<int> countDocumentsWithParkingStatusStream() {
    // Whenever you need to update the stream, call this function
    _updateCount();
    return _countController.stream;
  }

  Future<void> _updateCount() async {
    try {
      int count = await userCollection.where("parkingStatus", isEqualTo: true).get().then((querySnapshot) => querySnapshot.size);
      _countController.add(count);
    } catch (e) {
      print(e.toString());
      _countController.addError(e);
    }
  }

  Future<bool> checkEmailDocumentUserExist(String myEmail) async {
    try {
      QuerySnapshot<Object?> querySnapshot = await userCollection.where("email", isEqualTo: myEmail).get();
      bool check = querySnapshot.docs.isNotEmpty;
      return check;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void dispose() {
    _countController.close();
  }
}
