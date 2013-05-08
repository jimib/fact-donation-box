/*
  Web client
 
 This sketch connects to a website (http://www.google.com)
 using an Arduino Wiznet Ethernet shield. 
 
 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 
 created 18 Dec 2009
 by David A. Mellis
 modified 9 Apr 2012
 by Tom Igoe, based on work by Adrian McEwen
 
 */

#include <SPI.h>
#include <Ethernet.h>

// Enter a MAC address for your controller below.
// Newer Ethernet shields have a MAC address printed on a sticker on the shield
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
// if you don't want to use DNS (and reduce your sketch size)
// use the numeric IP instead of the name for the server:
//IPAddress server(74,125,232,128);  // numeric IP for Google (no DNS)
char server[] = "scala-messager.jimib.co.uk";    // name address for Google (using DNS)

// Set the static IP address to use if the DHCP fails to assign
IPAddress ip(192,168,0,177);

// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
EthernetClient client;

static const int NUM_BUTTONS = 4;
int buttonInputs[NUM_BUTTONS] = {14,15,16,17};
boolean buttonStates[NUM_BUTTONS] = {false, false, false, false};
String buttonVideos[NUM_BUTTONS] = {"video1", "video2", "video3", "video4"};

void setup() {
 // Open serial communications and wait for port to open:
  Serial.begin(9600);
   while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }

  // start the Ethernet connection:
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Failed to configure Ethernet using DHCP");
    // no point in carrying on, so do nothing forevermore:
    // try to congifure using IP address instead of DHCP:
    Ethernet.begin(mac, ip);
  }
  
  delay(1000);
  
  //set up the buttons
  for(int i = 0; i < NUM_BUTTONS; i++){
    // initialize the pushbutton pin as an input:
    pinMode(buttonInputs[i], INPUT);
    digitalWrite(buttonInputs[i], HIGH); // connect internal pull-up
  }
}


void loop(){
  //Serial.println("loop");
  //check the states of all the buttons
  for(int i = 0; i < NUM_BUTTONS; i++){
    //check the state of the button
    boolean state = isButtonDown(buttonInputs[i]);
    if(state != buttonStates[i]){
      Serial.println("State changed");
      //record the state
      buttonStates[i] = state;
      //act depending if button up or down
      if(state){
        Serial.print("Button Pressed: ");
        Serial.println(i);
        playVideo(buttonVideos[i]);
      }else{
        Serial.print("Button Released: ");
        Serial.println(i);
      }
    }
  }
  
  delay(100);
}

boolean isButtonDown(int pinInput){
   if(digitalRead(pinInput) == HIGH){
     return false;
   }else{
     return true;
   }
}

void playVideo(String src){
  // give the Ethernet shield a second to initialize:
  //Serial.println("connecting...");

  // if you get a connection, report back via serial:
  if (client.connect(server, 80)) {
    //Serial.println("connected");
    // Make a HTTP request:
    String getRequestString = "GET /play/?idScreen=donationBox&srcVideo="+src+" HTTP/1.1";  
    char getRequest[100];
    getRequestString.toCharArray(getRequest, 100);
    
    char hostRequest[100] = "Host: \0";
    strcat(hostRequest, server);
    
    //Serial.println(hostRequest);
    
    client.println(getRequest);
    client.println(hostRequest);
    client.println("Connection: close");
    client.println();
    
    delay(1000);
    client.stop();
    //Serial.println("closed connection");
  } 
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
  }
}

