#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "Admin.cpp"
#include "User.cpp"
#include "Network.h"
#include "time.h"
//#include <HardwareSerial.h>
#define RX_PIN 13
#define TX_PIN 12
HTTPClient http;
DynamicJsonDocument docJson (2048);

Network *network;
User *user;
Admin *admin;

// User
#define urlGetUserDocuments "https://firestore.googleapis.com/v1/projects/parkingcarapp-ef7de/databases/(default)/documents/Users"
#define urlPatchUserDocument "https://firestore.googleapis.com/v1/projects/parkingcarapp-ef7de/databases/(default)/documents/Users"
#define urlUserDocumentsWithQuery "https://firestore.googleapis.com/v1/projects/parkingcarapp-ef7de/databases/(default)/documents:runQuery"

// Admin
#define urlAdminCollection "https://firestore.googleapis.com/v1/projects/parkingcarapp-ef7de/databases/(default)/documents/Admin/"
#define AdminId "UubQplMKWDSdTiNhuYpONLh6cnk2"


char* Init = "0";
char* Vehicle_sent_successfully = "1";
char* Vehicle_retrieved_successfully = "2";
char* Account_not_registered = "3";
char* Account_not_enough_money = "4";
char* RFID_not_registered = "5";
char* RFID_added_successfully = "6";
char* Network_error = "7";
char* Wifi_not_connected = "8";

int mytime = 0;
int hasRFID = 1;  
char MaThe[11];
bool RX_Flag;
char KyTuNhan;
char ChuoiNhan[16];
int chiso = 0;
char TinHieuNutNhan[1];
HardwareSerial STM32(1);


// Config Time
const char* ntpServer = "pool.ntp.org";
const long gmtOffset_sec = 7 * 3600;  // Múi giờ Việt Nam (UTC+7)
const int daylightOffset_sec = 3600;


void setup() {
  Serial.begin(115200);
  //while (!Serial) continue;
  pinMode(RX_PIN, INPUT);
  pinMode(TX_PIN, OUTPUT);
  STM32.begin(115200, SERIAL_8N1, RX_PIN, TX_PIN);
  initNetwork();
  user = new User();
  admin = new Admin();
  // Init and get the time
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  http.setReuse(true);
  http.begin("https://firestore.googleapis.com/v1/projects/parkingcarapp-ef7de/");
}

void loop() {
  //if ((millis() - mytime) > 3000 || mytime == 0) {
    if (WiFi.status() == WL_CONNECTED){
      if (STM32.available() > 0){
        // Nhan ma the RFID tu Uart
        RX_Flag = 1;
        while (RX_Flag) {
          HamNhanRX(MaThe);
        }
        //MaThe[11] = '\0';
        int Array[11];
        for (int i = 0; i < strlen(MaThe); i++)
        {
         Array[i] = int (MaThe[i]);
         Serial.println(Array[i]);
        }
        String RFID_from_STM32 = arrayToString(Array, 5);
       // Serial.println("RFID from STM32: " + RFID_from_STM32);
        MappingAdminDocument(GetAdminDocument());
        
        // Add or update RFID
        if (admin->getUpdatingStatus()){
          String response;
          response = GetDocumentUserWithQuery(admin->getEmailUser(), "", "");
          if(!response.isEmpty()){
            MappingUserDocument(response);  // Thực hiện truy vấn user có email và password khớp
            user->setRFID(RFID_from_STM32);
            if (user->getEmail().isEmpty()){
              // TK khong ton tai
              HamGuiTX(Account_not_registered);
            }
            // Add RFID for user
            else{
              if (UpdateOneDocumentUser() == 200){  
                admin->setUpdatingStatus(false);
                if (UpdateOneDocumentAdmin() == 200){
                  // Them RFID thanh cong
                  HamGuiTX(RFID_added_successfully);
                }
                else{
                  // Network_error
                  HamGuiTX(Network_error);
                }
              }
              else{
                // Network_error
                HamGuiTX(Network_error);
              }
            }   
          }
          else{
            // Network_error
            HamGuiTX(Network_error);
          }
        }

        // Handling parking or picking up vehicles
        else{
          String response;
          response = GetDocumentUserWithQuery("", "", RFID_from_STM32);
          if (!response.isEmpty()){
            MappingUserDocument(response);  // Thực hiện truy vấn user có RFID khớp
            if (user->getRFID() == RFID_from_STM32){
              if (user->getParkingStatus() == false)  // Gửi xe
              {
                int money = user->getMoney();
                if (money < admin->getParkingFee()){
                  // Khong du tien;
                  String currentDate, currentTime;
                  LocalTime(currentDate, currentTime);
                  HamGuiTX(Account_not_enough_money);
                  delay(5);
                  RX_Flag = 1;
                  while (RX_Flag)
                    if (STM32.available() > 0)
                      HamNhanRX(TinHieuNutNhan);
                  if (strcmp(TinHieuNutNhan, "1") == 0)
                  {
                    user->setParkingStatus(true);
                    user->setParkingDate(currentDate);
                    user->setParkingTime(currentTime);
                    admin->setRevenue(admin->getRevenue() + admin->getParkingFee());
                    admin->setCarPassengerCount(admin->getCarPassengerCount() + 1);
                    UpdateOneDocumentAdmin();
                    UpdateOneDocumentUser();
                    String biensoxe = user->getLicensePlate();
                    char buffer[20];  // Adjust the size accordingly
                    biensoxe.toCharArray(buffer, sizeof(buffer));
                    HamGuiTX(buffer);
                  }
                }
                else{
                  String currentDate, currentTime;
                  LocalTime(currentDate, currentTime);
                  user->setMoney(money - admin->getParkingFee());   
                  user->setParkingStatus(true);
                  user->setParkingDate(currentDate);
                  user->setParkingTime(currentTime);
                  admin->setRevenue(admin->getRevenue() + admin->getParkingFee());
                  admin->setCarPassengerCount(admin->getCarPassengerCount() + 1);
                  if (UpdateOneDocumentAdmin() == 200){
                  }
                  else{
                    // Network_error
                    HamGuiTX(Network_error);
                  }
                  if (UpdateOneDocumentUser() == 200){
                    // Gui xe thanh cong
                    HamGuiTX(Vehicle_sent_successfully);
                    delay(5);
                    String biensoxe = user->getLicensePlate();
                    // Create a mutable copy
                    char buffer[20];  // Adjust the size accordingly
                    biensoxe.toCharArray(buffer, sizeof(buffer));
                    HamGuiTX(buffer);
                  }
                  else{
                    // Network_error
                    HamGuiTX(Network_error);
                  }
                }
              }
              else if (user->getParkingStatus() == true) // Lấy xe
              {
                String currentDate, currentTime;
                LocalTime(currentDate, currentTime);
                user->setParkingStatus(false);
                user->setParkingDate(currentDate);
                user->setParkingTime(currentTime);
                admin->setCarPassengerCount(admin->getCarPassengerCount() - 1);
                if (UpdateOneDocumentAdmin() == 200){
                  }
                else{
                  // Network_error
                  HamGuiTX(Network_error);
                }
                if (UpdateOneDocumentUser() == 200){
                  // Lay xe thanh cong
                  HamGuiTX(Vehicle_retrieved_successfully);
                  delay(5);
                  String biensoxe = user->getLicensePlate();
                  // Create a mutable copy
                  char buffer[20];  // Adjust the size accordingly
                  biensoxe.toCharArray(buffer, sizeof(buffer));
                  HamGuiTX(buffer);
                }
                else{
                  // Network_error
                  HamGuiTX(Network_error);
                }
              }
            }
            else{
              // Chưa đăng ký RFID
              HamGuiTX(RFID_not_registered);
            }
          }
          else{
            // Network_error
            HamGuiTX(Network_error);
          }
        }
      }
    }
    else {
        // Chưa kết nối wifi
        HamGuiTX(Wifi_not_connected);
    }
  //}
}

void initNetwork() {
  network = new Network();
  network->initWiFi();
}


// Map User document
void MappingUserDocument(String payload){
  docJson.clear(); // Xóa nội dung JSON document trước khi thêm dữ liệu mới
  DeserializationError error = deserializeJson(docJson, payload);

  if (error){
   // Serial.print("Error: ");
    //Serial.println(error.c_str());
  }else {
    // Trích xuất ID document
    String documentID = extractDocumentID(docJson[0]["document"]["name"].as<String>());
   // Serial.println("ID document: " + documentID);

    // Đặt các thuộc tính người dùng dựa trên dữ liệu JSON
    user->setUID(documentID);
    user->setUserName(docJson[0]["document"]["fields"]["userName"]["stringValue"].as<String>());
    user->setEmail(docJson[0]["document"]["fields"]["email"]["stringValue"].as<String>());
    user->setPassword(docJson[0]["document"]["fields"]["password"]["stringValue"].as<String>());
    user->setLicensePlate(docJson[0]["document"]["fields"]["licensePlate"]["stringValue"].as<String>());
    user->setRFID(docJson[0]["document"]["fields"]["RFID"]["stringValue"].as<String>());
    user->setMoney(docJson[0]["document"]["fields"]["money"]["integerValue"].as<int>());
    user->setParkingDate(docJson[0]["document"]["fields"]["parkingDate"]["stringValue"].as<String>());
    user->setParkingTime(docJson[0]["document"]["fields"]["parkingTime"]["stringValue"].as<String>()); 
    user->setParkingStatus(docJson[0]["document"]["fields"]["parkingStatus"]["booleanValue"].as<bool>());
  
    // In thông tin của User
    // Serial.println("uid: " + user->getUID());
    // Serial.println("Username: " + user->getUserName());
    // Serial.println("Email: " + user->getEmail());
    // Serial.println("Password: " + user->getPassword());
    // Serial.println("License Plate: " + user->getLicensePlate());
    // Serial.println("RFID: " + user->getRFID());
    // Serial.println("Money: " + String(user->getMoney()));
    // Serial.println("Parking Date: " + user->getParkingDate());
    // Serial.println("Parking Time: " + user->getParkingTime());
    // Serial.println("Parking Status: " + String(user->getParkingStatus()));
  }
}

// Get all documents in collection Users - GET method
String GetAllDocumentsUser(){
  //HTTPClient http;
  String payload;

  //Serial.println("Free Heap Before Request: " + String(ESP.getFreeHeap()));
  http.begin(urlGetUserDocuments);

  //Serial.println("Sending HTTP GET request...");
  int httpResponseCode = http.GET();
  if (httpResponseCode > 0) {
    payload = http.getString();
    //Serial.println("Response: " + payload);
  } else {
    // Serial.print("HTTP GET request failed, error code: ");
    // Serial.println(httpResponseCode);
  }
  http.end();
  return payload;
}

// Update a specific document in collection Users - PATCH method
int UpdateOneDocumentUser(){
  StaticJsonDocument<500> buffer;
  JsonObject fields = buffer.createNestedObject("fields");
  //HTTPClient http;
  String payload;
  String response;

  fields["RFID"]["stringValue"] = user->getRFID();
  fields["avatar"]["stringValue"] = "";
  fields["email"]["stringValue"] = user->getEmail();
  fields["licensePlate"]["stringValue"] = user->getLicensePlate();
  fields["money"]["integerValue"] = user->getMoney();
  fields["parkingDate"]["stringValue"] = user->getParkingDate();
  fields["parkingStatus"]["booleanValue"] = user->getParkingStatus();
  fields["parkingTime"]["stringValue"] = user->getParkingTime();
  fields["password"]["stringValue"] = user->getPassword();
  fields["userName"]["stringValue"] = user->getUserName();

  serializeJson(buffer,payload);
  //Serial.println("Free Heap Before Request: " + String(ESP.getFreeHeap()));
  
  String url = urlPatchUserDocument;
  url += "/";
  url += user->getUID();
  
  // getUID maybe null
  http.begin(url);
  http.addHeader("Accept", "application/json");

  //Serial.println("Sending HTTP PATCH request...");
  int httpResponseCode = http.PATCH(payload);
  if (httpResponseCode == 200) {
    response = http.getString();
    //Serial.println("Response (update Document): " + response);
  } else {
    // Serial.print("HTTP GET request failed, error code: ");
    // Serial.println(httpResponseCode);
  }
  http.end();
  return httpResponseCode;
}

// Returns a specified document that matches the queried value in document Users
String GetDocumentUserWithQuery(String email, String password, String RFID) {
  StaticJsonDocument<500> buff;
  //HTTPClient http;
  String payload;
  String response;

  // Tạo cấu trúc JSON cho truy vấn
  JsonObject structuredQuery = buff.createNestedObject("structuredQuery");
  JsonArray fromArray = structuredQuery.createNestedArray("from");
  JsonObject collectionId = fromArray.createNestedObject();
  collectionId["collectionId"] = "Users";

  // Tạo cấu trúc JSON cho điều kiện tìm kiếm
  JsonObject where = structuredQuery.createNestedObject("where");
  JsonObject compositeFilter = where.createNestedObject("compositeFilter");
  compositeFilter["op"] = "AND";
  compositeFilter["filters"] = compositeFilter.createNestedArray("filters");

  // Thêm điều kiện cho email
  if (email != "") {
    JsonObject emailFilter = compositeFilter["filters"].createNestedObject();
    emailFilter["fieldFilter"]["field"]["fieldPath"] = "email";
    emailFilter["fieldFilter"]["op"] = "EQUAL";
    emailFilter["fieldFilter"]["value"]["stringValue"] = email;
  }

  // Thêm điều kiện cho password
  if (password != "") {
    JsonObject passwordFilter = compositeFilter["filters"].createNestedObject();
    passwordFilter["fieldFilter"]["field"]["fieldPath"] = "password";
    passwordFilter["fieldFilter"]["op"] = "EQUAL";
    passwordFilter["fieldFilter"]["value"]["stringValue"] = password;
  }

  // Thêm điều kiện cho RFID
  if (RFID != "") {
    JsonObject RFIDFilter = compositeFilter["filters"].createNestedObject();
    RFIDFilter["fieldFilter"]["field"]["fieldPath"] = "RFID";
    RFIDFilter["fieldFilter"]["op"] = "EQUAL";
    RFIDFilter["fieldFilter"]["value"]["stringValue"] = RFID;
  }

  // Chuyển đổi cấu trúc JSON thành String
  serializeJson(buff, payload);
  // Serial.println("Payload with query document user" + payload);
  // Serial.println("Free Heap Before Request: " + String(ESP.getFreeHeap()));

  // Gửi HTTP POST request
  http.begin(urlUserDocumentsWithQuery);
  http.addHeader("Content-Type", "application/json");

  //Serial.println("Sending HTTP POST query document User Field...");
  int httpResponseCode = http.POST(payload);
  if (httpResponseCode == 200) {
    response = http.getString();
    //Serial.println("Response (with Query): " + response);
  } else {
    // Serial.print("HTTP POST request failed, error code: ");
    // Serial.println(httpResponseCode);
  }

  http.end();
  return response;
}

// Get admin docmuent - GET method
String GetAdminDocument(){
  //HTTPClient http;
  String payload;
  String url = urlAdminCollection;
  url += AdminId;
  http.begin(url);

  //Serial.println("Sending HTTP GET admin docmuent");
  int httpResponseCode = http.GET();
  if (httpResponseCode > 0) {
    payload = http.getString();
    //Serial.println("Response: " + payload);
  } else {
    //Serial.print("HTTP GET request failed, error code: ");
    //Serial.println(httpResponseCode);
  }
  http.end();
  return payload;
}

// Map data from Admin document to Admin class
void MappingAdminDocument(String payload){
  docJson.clear(); // Xóa nội dung JSON document trước khi thêm dữ liệu mới
  DeserializationError error = deserializeJson(docJson, payload);

  if (error){
    // Serial.print("Error: ");
    // Serial.println(error.c_str());
  }else {
    admin->setEmail(docJson["fields"]["email"]["stringValue"].as<String>());
    admin->setPassword(docJson["fields"]["password"]["stringValue"].as<String>());
    admin->setAdminName(docJson["fields"]["adminName"]["stringValue"].as<String>());
    admin->setAvatar(docJson["fields"]["avatar"]["stringValue"].as<String>());
    admin->setCarSlot(docJson["fields"]["carSlot"]["integerValue"].as<int>());
    admin->setParkingFee(docJson["fields"]["parkingFee"]["integerValue"].as<int>());
    admin->setRevenue(docJson["fields"]["revenue"]["integerValue"].as<unsigned long>());
    admin->setEmailUser(docJson["fields"]["updateRFIDStatus"]["mapValue"]["fields"]["emailUser"]["stringValue"].as<String>());
    admin->setUpdatingStatus(docJson["fields"]["updateRFIDStatus"]["mapValue"]["fields"]["updatingStatus"]["booleanValue"].as<bool>());
    admin->setCarPassengerCount(docJson["fields"]["carPassengerCount"]["integerValue"].as<int>());
  
    //Print out the mappable information
    // Serial.println("Admin Name: " + admin->getAdminName());
    // Serial.println("Email: " + admin->getEmail());
    // Serial.println("Password: " + admin->getPassword());
    // Serial.println("Avatar: " + admin->getAvatar());
    // Serial.println("Parking Fee: " + String(admin->getParkingFee()));
    // Serial.println("Car Slot: " + String(admin->getCarSlot()));
    // Serial.println("Email user: " + admin->getEmailUser());
    // Serial.println("Password user: " + admin->getPasswordUser());
    // Serial.println("Updating parking enable: " + String(admin->getUpdatingStatus()));
  }
}

// Update a specific document in collection Admin - PATCH method
int UpdateOneDocumentAdmin(){
  StaticJsonDocument<500> buffer;
  JsonObject fields = buffer.createNestedObject("fields");
  //HTTPClient http;
  String payload;
  String response;

  fields["adminName"]["stringValue"] = admin->getAdminName();
  fields["avatar"]["stringValue"] = admin->getAvatar();
  fields["carPassengerCount"]["integerValue"] = admin->getCarPassengerCount();
  fields["carSlot"]["integerValue"] = admin->getCarSlot();
  fields["email"]["stringValue"] = admin->getEmail();
  fields["parkingFee"]["integerValue"] = admin->getParkingFee(); 
  fields["password"]["stringValue"] = admin->getPassword();
  fields["revenue"]["integerValue"] = admin->getRevenue();
  JsonObject updateRFIDStatusFilter = fields["updateRFIDStatus"].createNestedObject("mapValue");
  updateRFIDStatusFilter["fields"]["emailUser"]["stringValue"] = admin->getEmailUser();
  updateRFIDStatusFilter["fields"]["updatingStatus"]["booleanValue"] = admin->getUpdatingStatus();

  serializeJson(buffer,payload);
  // Serial.println("Payload with update document Admin" + payload);
  // Serial.println("Free Heap Before Request: " + String(ESP.getFreeHeap()));
  
  
  // getUID maybe null
  String url = urlAdminCollection;
  url += AdminId;
  http.begin(url);
  http.addHeader("Accept", "application/json");

  //Serial.println("Sending HTTP PATCH update Document Admin ...");
  int httpResponseCode = http.PATCH(payload);
  if (httpResponseCode == 200) {
    response = http.getString();
    //Serial.println("Response (update Document): " + response);
  } else {
    // Serial.print("HTTP PATCH request failed, error code: ");
    // Serial.println(httpResponseCode);
  }
  http.end();
  return httpResponseCode;
}

String extractDocumentID(String path) {
  // Tìm vị trí của dấu gạch chéo cuối cùng trong đường dẫn
  int lastSlashIndex = path.lastIndexOf('/');
  
  // Trích xuất phần sau dấu gạch chéo cuối cùng
  String documentID = path.substring(lastSlashIndex + 1);
  
  return documentID;
}

void LocalTime(String &tempdate, String &temptime){
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return;
  }
  Serial.println("Time variables");
  
  // Time
  char timeHour[3];
  strftime(timeHour,3, "%H", &timeinfo);
  char timeMinute[3];
  strftime(timeMinute,3, "%M", &timeinfo);
  char timeSecond[3];
  strftime(timeSecond,3, "%S", &timeinfo);

  // Date
  char day[3];
  strftime(day,3, "%d", &timeinfo);
  char month[9];
  strftime(month,9, "%B", &timeinfo);
  char year[5];
  strftime(year,5, "%Y", &timeinfo);

 temptime = String(timeHour) + ":" + String(timeMinute) + ":" + String(timeSecond);
  tempdate = String(day) + "-" + String(month) + "-" + String(year);
}


//Ham Nhan
void HamNhanRX(char* ChuoiNhan)
{
  while (STM32.available() != 0)
  {
    KyTuNhan = STM32.read();
    ChuoiNhan[chiso] = KyTuNhan;
    chiso++;
  }
  chiso = 0;
  RX_Flag = 0;
  delay(1);
}

//Ham Gui
void HamGuiTX(char*ChuoiGui)
{
  STM32.print(ChuoiGui);
  for (int i = 0; i < 11 - strlen(ChuoiGui); i++)
  {
    STM32.write('\0');
  }
}
String arrayToString(int arr[], int length) {
  String result = "";

  for (int i = 0; i < length; i++) {
    result += String(arr[i]);
  }
  return result;
}

