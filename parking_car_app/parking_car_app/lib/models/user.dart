class UserModels {
  final String uid;
  final String? email;

  UserModels({
    required this.uid,
    required this.email,
  });
}

class UserData {
  final String uid;
  final String email;
  final String password;
  final String avatar;
  final String userName;
  final String RFID;
  final int money;
  final String parkingDate;
  final String parkingTime;
  final bool parkingStatus;
  final String licensePlate;

  UserData({
    required this.uid,
    required this.email,
    required this.password,
    required this.avatar,
    required this.userName,
    required this.RFID,
    required this.money,
    required this.parkingDate,
    required this.parkingTime,
    required this.parkingStatus,
    required this.licensePlate,
  });
}
