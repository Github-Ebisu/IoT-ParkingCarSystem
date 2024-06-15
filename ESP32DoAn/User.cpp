#include <WString.h>

class User {
private:
  String uid;
  String RFID;
  String avatar;
  String email;
  int money;
  String parkingDate;
  bool parkingStatus;
  String parkingTime;
  String password;
  String userName;
  String licensePlate;

public:
  // Constructors
  User() {
    uid = "";
    RFID = "";
    avatar = "";
    email = "";
    money = 0;
    parkingDate = "";
    parkingStatus = false;
    parkingTime = "";
    password = "";
    userName = "";
    licensePlate = "";
  }

  // Deconstructors
  ~User(){
    
  }

  // Getters
  String getUID() const {
    return uid;
  }

  String getRFID() const {
    return RFID;
  }

  String getAvatar() const {
    return avatar;
  }

  String getEmail() const {
    return email;
  }

  int getMoney() const {
    return money;
  }

  String getParkingDate() const {
    return parkingDate;
  }

  bool getParkingStatus() const {
    return parkingStatus;
  }

  String getParkingTime() const {
    return parkingTime;
  }

  String getPassword() const {
    return password;
  }

  String getUserName() const {
    return userName;
  }

  String getLicensePlate() const {
    return licensePlate;
  }

  // Setters
  void setUID(const String& newUID) {
    uid = newUID;
  }

  void setRFID(const String& newRFID) {
    RFID = newRFID;
  }

  void setAvatar(const String& newAvatar) {
    avatar = newAvatar;
  }

  void setEmail(const String& newEmail) {
    email = newEmail;
  }

  void setMoney(int newMoney) {
    money = newMoney;
  }

  void setParkingDate(const String& newParkingDate) {
    parkingDate = newParkingDate;
  }

  void setParkingStatus(bool newParkingStatus) {
    parkingStatus = newParkingStatus;
  }

  void setParkingTime(const String& newParkingTime) {
    parkingTime = newParkingTime;
  }

  void setPassword(const String& newPassword) {
    password = newPassword;
  }

  void setUserName(const String& newUserName) {
    userName = newUserName;
  }

  void setLicensePlate(const String& newLicensePlate) {
    licensePlate = newLicensePlate;
  }
};
