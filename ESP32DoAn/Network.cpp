#include "Network.h"


#define WIFI_SSID "son "
#define WIFI_PASSWORD "0919559330"

#define API_KEY "AIzaSyDrX5ni-Lonj3pFc0CGdVmeYBVeATOliYw"
#define FIREBASE_PROJECT_ID "parkingcarapp-ef7de"
#define USER_EMAIL "test1@gmail.com"
#define USER_PASSWORD "123456789"

static Network *instance = NULL;

Network::Network(){
  instance = this;
}

void WiFiEventConnected(WiFiEvent_t event, WiFiEventInfo_t info){
  Serial.println("Wifi connected ! But wait for the local IP address.");
}

void WiFiEventGotIP(WiFiEvent_t event, WiFiEventInfo_t info){
  Serial.print("Local IP address: ");
  Serial.println(WiFi.localIP());
  
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  Serial.print("RSSI: ");
  Serial.println(WiFi.RSSI());

  Serial.print("MAC: ");
  Serial.println(WiFi.macAddress());
  
  Serial.print("GatewayIP: ");
  Serial.println(WiFi.gatewayIP());
  
  Serial.print("DNS: ");
  Serial.println(WiFi.dnsIP());
}

void WiFiEventDisconnected(WiFiEvent_t event, WiFiEventInfo_t info){
  Serial.print(".");
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  delay(500);
}


void Network::initWiFi(){
  WiFi.disconnect();
  WiFi.onEvent(WiFiEventConnected, ARDUINO_EVENT_WIFI_STA_CONNECTED);
  WiFi.onEvent(WiFiEventGotIP, ARDUINO_EVENT_WIFI_STA_GOT_IP);
  WiFi.onEvent(WiFiEventDisconnected, ARDUINO_EVENT_WIFI_STA_DISCONNECTED);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
}
