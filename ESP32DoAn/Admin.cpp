#include <WString.h>

class Admin {
  private:
    String email;
    String password;
    String adminName;
    String avatar;
    int parkingFee;
    int carSlot;
    String emailUser;
    bool updatingStatus;
    unsigned long revenue;
    int carPassengerCount;

  public:
    // Constructor mặc định
    Admin()
        : email("default_email"), password("default_password"),
          adminName("default_adminName"), avatar("default_avatar"),
          parkingFee(0), carSlot(0), emailUser("default_emailUser"), updatingStatus(false),
          revenue(0),  carPassengerCount(0){}

    // Constructor với đối số
    Admin(String _email, String _password, String _adminName, String _avatar,
          int _parkingFee, int _carSlot, String _emailUser, String _passwordUser,
          bool _updatingStatus, unsigned long _revenue, int _carPassengerCount)
        : email(_email), password(_password), adminName(_adminName),
          avatar(_avatar), parkingFee(_parkingFee), carSlot(_carSlot),
          emailUser(_emailUser),
          updatingStatus(_updatingStatus), revenue(_revenue),
          carPassengerCount(_carPassengerCount) {}

    // Deconstructor
    ~Admin() {}

    // Getter methods
    String getEmail() const {
        return email;
    }

    String getPassword() const {
        return password;
    }

    String getAdminName() const {
        return adminName;
    }

    String getAvatar() const {
        return avatar;
    }

    int getParkingFee() const {
        return parkingFee;
    }

    int getCarSlot() const {
        return carSlot;
    }

    String getEmailUser() const {
        return emailUser;
    }

    bool getUpdatingStatus() const {
        return updatingStatus;
    }

    // Getter method for revenue
    unsigned long getRevenue() const {
        return revenue;
    }

    // Setter methods
    void setEmail(String _email) {
        email = _email;
    }

    void setPassword(String _password) {
        password = _password;
    }

    void setAdminName(String _adminName) {
        adminName = _adminName;
    }

    void setAvatar(String _avatar) {
        avatar = _avatar;
    }

    void setParkingFee(int _parkingFee) {
        parkingFee = _parkingFee;
    }

    void setCarSlot(int _carSlot) {
        carSlot = _carSlot;
    }

    void setEmailUser(String _emailUser) {
        emailUser = _emailUser;
    }

    void setUpdatingStatus(bool _updatingStatus) {
        updatingStatus = _updatingStatus;
    }

    // Setter method for revenue
    void setRevenue(unsigned long _revenue) {
        revenue = _revenue;
    }
    int getCarPassengerCount() const {
        return carPassengerCount;
    }

    // New setter method for car passenger count
    void setCarPassengerCount(int _carPassengerCount) {
        carPassengerCount = _carPassengerCount;
    }
};
