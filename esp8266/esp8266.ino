#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>

const char* ssid = "NoteEight";  // Enter SSID here
const char* password = "170501123";  //Enter Password here

ESP8266WebServer server(80);

uint8_t LED1pin = D0;
uint8_t LED2pin = D1;
uint8_t motorKeyPin = D2;
uint8_t starterPin = D3;

bool LED1status = false;
bool LED2status = false;
bool autostart = false;
bool isUsingKey = false;

int motorKeyState = 0;
int starterState = 0;
int contactState = 0;
int x = 0;

String response;

StaticJsonDocument<256> jsonDoc;

void setup() {
  Serial.begin(115200);
  pinMode(LED1pin, OUTPUT);
  pinMode(LED2pin, OUTPUT);
  pinMode(motorKeyPin, INPUT_PULLUP);
  pinMode(starterPin, INPUT_PULLUP);

  digitalWrite(LED1pin, HIGH);
  digitalWrite(LED2pin, HIGH);

  WiFi.begin(ssid, password);

  delay(100);
  // return html response
  server.on("/", handleOnConnect);
  server.on("/onetouch", handleOnetouchHtml);
  server.on("/engineon", handleEngineOnHtml);
  server.on("/engineoff", handleEngineOffHtml);
  server.on("/contacton", handleContactOnHtml);
  server.on("/contactoff", handleContactOffHtml);
  server.on("/emergencyon", handleEmergencyOnHtml);
  server.on("/emergencyoff", handleEmergencyOffHtml);
  server.onNotFound(handleNotFound);

  // return json response
  server.on("/engine/on", handleEngineOnJson);
  server.on("/engine/off", handleEngineOffJson);
  server.on("/contact/on", handleContactOnJson);
  server.on("/contact/off", handleContactOffJson);
  server.on("/emergency/on", handleEmergencyOnJson);
  server.on("/emergency/off", handleEmergencyoffJson);

  server.begin();
  Serial.println("HTTP server started");
  server.send(200, "text/html", sendHTML(false, false));
}

void loop() {
  server.handleClient();
  delay(500);
  WiFi.RSSI();

  contactState = digitalRead(LED1pin);
  motorKeyState = digitalRead(motorKeyPin);
  if(contactState == HIGH){
    if (motorKeyState == LOW) {
     isUsingKey = true;
     handleContactOnHtml();
    }  
  } else {
    // unplug motorcycle key
    if(isUsingKey && motorKeyState == HIGH){
     handleContactOffHtml();
      isUsingKey = false;
    } 
  }
  
  starterState = digitalRead(starterPin);
  if (starterState == LOW && motorKeyState == LOW) {
    digitalWrite(LED2pin,LOW);
  } else {
    digitalWrite(LED2pin,HIGH);
  }

  Serial.println("WIFI RSSI :");
  Serial.println(WiFi.RSSI());
  
  if(!isUsingKey){
    if (WiFi.RSSI() < -80 && LED2status == false)
    {
      Serial.println("motor should be TURN OFF");
      handleEngineOffHtml();
    }
     else if (WiFi.RSSI()> -50 && WiFi.RSSI() < 0 && LED2status == false && autostart == false)
    {
      Serial.println("turn on Contact");
      digitalWrite(LED1pin, LOW);
      x=x+1;
      if (x==6)
      {
        autostart=true;
        Serial.println("auto start MOTOR 3S");
        handleEngineOnHtml();
      }
    }
    else if ((WiFi.status() == 1 || WiFi.status() == 7) && LED2status == false)
    {
      Serial.println("LOST WIFI turn of MOTOR");
      handleEngineOffHtml();   
    }  
  }
}

void handleOnConnect() {
  server.send(200, "text/html", sendHTML(LED1status, LED2status));
}

void handleOnetouchHtml() {
  LED1status = true;
  digitalWrite(LED1pin, LOW);
  server.send(200, "text/html", sendHTML(true, LED2status));
  delay(3000);
  digitalWrite(LED2pin, LOW);
  delay(300);
  digitalWrite(LED2pin, HIGH);
}

void handleEngineOnHtml() {
  digitalWrite(LED2pin, LOW);
  delay(300);
  digitalWrite(LED2pin, HIGH);
  server.send(200, "text/html", sendHTML(LED1status, true));
}

void handleEngineOnJson(){
  if(digitalRead(LED1pin) != LOW){
    digitalWrite(LED1pin,LOW);
    delay(3000);
  }
  digitalWrite(LED2pin, LOW);
  JsonObject obj = jsonDoc.to<JsonObject>();
  if(digitalRead(LED2pin) == LOW){
    obj["status"] = "success";
    obj["message"] = "engine started successfully";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(200,"application/json",response);
    response = "";
    jsonDoc.clear();
  } else {
    obj["status"] = "failed";
    obj["message"] = "module error: starter cannot be turned on";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(500,"application/json",response);
    response = "";
    jsonDoc.clear();
  }
  delay(300);
  digitalWrite(LED2pin, HIGH);
}

void handleEngineOffHtml() {
  digitalWrite(LED1pin, HIGH);
  x = 0;
  autostart = false;
  server.send(200, "text/html", sendHTML(false, LED2status));
}

void handleEngineOffJson(){
  digitalWrite(LED1pin, HIGH);
  JsonObject obj = jsonDoc.to<JsonObject>();
  if(digitalRead(LED1pin) == HIGH){
    obj["status"] = "success";
    obj["message"] = "engine stopped successfully";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(200,"application/json",response);
    response = "";
    jsonDoc.clear();
  } else {
    obj["status"] = "failed";
    obj["message"] = "module error: engine cannot be turned off";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(500,"application/json",response);
    response = "";
    jsonDoc.clear();
  }
  x = 0;
  autostart = false;
}

void handleEmergencyOffHtml() {
  LED2status = false;
  server.send(200, "text/html", sendHTML(LED1status, false));
}

void handleEmergencyoffJson(){
  LED2status = false;
  JsonObject obj = jsonDoc.to<JsonObject>();
  if(LED2status == false){
    obj["status"] = "success";
    obj["message"] = "emergency mode turned off successfully";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(200,"application/json",response);
    response = "";
    jsonDoc.clear();
  } else {  
    obj["status"] = "failed";
    obj["message"] = "module error: emergency mode cannot be turned off";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(500,"application/json",response);
    response = "";
    jsonDoc.clear();
  }
}

void handleEmergencyOnHtml() {
  LED2status = true;
  server.send(200, "text/html", sendHTML(LED1status, true));
}

void handleEmergencyOnJson(){
  LED2status = true;
  JsonObject obj = jsonDoc.to<JsonObject>();
  if(LED2status == true){
    obj["status"] = "success";
    obj["message"] = "emergency mode turned on successfully";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(200,"application/json",response);
    response = "";
    jsonDoc.clear();  
  } else {
    obj["status"] = "failed";
    obj["message"] = "module error: emergency mode cannot be turned on";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(500,"application/json",response);
    response = "";
    jsonDoc.clear();  
  }
}

void handleContactOnHtml() {
  LED1status = true;
  digitalWrite(LED1pin, LOW);
  server.send(200, "text/html", sendHTML(true, LED2status));
}

void handleContactOnJson(){
  LED1status = true;
  digitalWrite(LED1pin, LOW);
  JsonObject obj = jsonDoc.to<JsonObject>();
  if(digitalRead(LED1pin) == LOW){
    obj["status"] = "success";
    obj["message"] = "contact turned on successfully";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(200,"application/json",response);
    response = "";
    jsonDoc.clear();  
  } else {
    obj["status"] = "failed";
    obj["message"] = "module error: contact cannot be turned on";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(500,"application/json",response);
    response = "";
    jsonDoc.clear();  
  }
}

void handleContactOffHtml() {
  LED1status = false;
  autostart = false;
  x = 0;
  digitalWrite(LED1pin, HIGH);
  server.send(200, "text/html", sendHTML(false, LED2status));
}

void handleContactOffJson(){
  LED1status = false;
  autostart = false;
  x = 0;
  digitalWrite(LED1pin, HIGH);
  JsonObject obj = jsonDoc.to<JsonObject>();
  if(digitalRead(LED1pin) == HIGH){
    obj["status"] = "success";
    obj["message"] = "contact turned off successfully";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(200,"application/json",response);
    response = "";
    jsonDoc.clear();  
  } else {
    obj["status"] = "failed";
    obj["message"] = "module error: contact cannot be turned off";
    serializeJson(jsonDoc,response);
    Serial.println(response);
    server.send(500,"application/json",response);
    response = "";
    jsonDoc.clear();  
  }
}

void handleNotFound() {
  JsonObject obj = jsonDoc.to<JsonObject>();
  obj["status"] = "failed";
  obj["message"] = "not found";
  serializeJson(jsonDoc,response);
  Serial.println(response);
  server.send(404,"application/json",response);
  response = "";
  jsonDoc.clear();  
}

String sendJsonResponse(int statusCode,String responseStatus, String message){
  
  JsonObject obj = jsonDoc.to<JsonObject>();
  obj["status"] = responseStatus;
  obj["message"] = message;
  serializeJson(jsonDoc,response);
  Serial.println(response);
  server.send(statusCode,"application/json",response);
  response = "";
  jsonDoc.clear();
}


String sendHTML(uint8_t led1stat, uint8_t led2stat) {
  String ptr = "<!DOCTYPE html> <html>\n";
  ptr += "<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\">\n";
  ptr += "<title>MotorCycle</title>\n";
  ptr += "<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}\n";
  ptr += "body{margin-top: 50px;} h1 {color: #444444;margin: 50px auto 30px;} h3 {color: #444444;margin-bottom: 50px;}\n";

  ptr += ".button {display: block;width: 200px;background-color: #1abc9c;border: none;color: white;padding: 13px 10px;text-decoration: none;font-size: 25px;margin: 0px auto 35px;cursor: pointer;border-radius: 4px;}\n";
  ptr += ".button-on {background-color: #1abc9c;}\n";
  ptr += ".button-on:active {background-color: #16a085;}\n";
  ptr += ".button-off {background-color: #34495e;}\n";
  ptr += ".button-off:active {background-color: #2c3e50;}\n";
  ptr += ".button-emergencyon {background-color: #e6c912;}\n";
  ptr += ".button-emergencyon:active {background-color: #c2aa11;}\n";
  ptr += ".button-emergencyoff {background-color: #ff0000;}\n";
  ptr += ".button-emergencyoff:active {background-color: #d60404;}\n";
  ptr += "p {font-size: 14px;color: #888;margin-bottom: 10px;}\n";
  ptr += "</style>\n";
  ptr += "</head>\n";
  ptr += "<body>\n";
  ptr += "<h1>Motorcycle Remote</h1>\n";
  if (led2stat)
  {

  }
  else
  {
    if (led1stat)
    {
      ptr += "<a class=\"button button-on\" href=\"/engineoff\">STOP ENGINE</a>\n";
      ptr += "<a class=\"button button-on\" href=\"/contactoff\">OFF CONTACT</a>\n";
    }
    else
    {
      ptr += "<a class=\"button button-off\" href=\"/onetouch\">1-TOUCH START</a>\n";
      ptr += "<a class=\"button button-off\" href=\"/contacton\">PRE-START</a>\n";
    }
  }

  if (led2stat)
  {
    ptr += "<a class=\"button button-emergencyoff\" href=\"/emergencyoff\">TURN OFF EMERGENCY</a>\n";
  }
  else
  {
    ptr += "<a class=\"button button-emergencyon\" href=\"/emergencyon\">TURN ON EMERGENCY</a>\n";
  }


  //  ptr +="<img src=\"https://iili.io/BbrlUv.th.jpg\" alt=\"BbrlUv.th.jpg\" border=\"0\">\n";//"<img src=\"https://homepages.cae.wisc.edu/~ece533/images/airplane.png\" width=\"250\" height=\"250\">\n";
  ptr += "</body>\n";
  ptr += "</html>\n";
  return ptr;
}
