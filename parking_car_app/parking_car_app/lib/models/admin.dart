class AdminData {
  final String uid;
  final String email;
  final String password;
  final String adminName;
  final String avatar;
  final int carSlot;
  final int parkingFee;
  final int revenue;
  final bool updatingStatus;
  final int carPassengerCount;

  AdminData({
    required this.uid,
    required this.email,
    required this.password,
    required this.avatar,
    required this.adminName,
    required this.carSlot,
    required this.parkingFee,
    required this.revenue,
    required this.updatingStatus,
    required this.carPassengerCount,
  });
}
