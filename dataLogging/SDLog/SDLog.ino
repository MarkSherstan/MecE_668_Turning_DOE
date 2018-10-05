// Based off Tom Igoe SD card datalogger example https://www.arduino.cc/en/Tutorial/Datalogger
// Shield uses pins 4, 11, 12, 13
// Use this???

#include <SPI.h>
#include <SD.h>
const int chipSelect = 4;
String fileName;

void setup() {
  Serial.begin(57600);

  Serial.print("Initializing SD card...");

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
  }

  Serial.println("card initialized.");

  String fileName = "datalog" + String(int(random(1, 100))) + ".txt";
  Serial.println(fileName);
}


void loop() {
  // make a string for assembling the data to log:
  String dataString = "";

  // read three sensors and append to the string:
  for (int analogPin = 0; analogPin < 3; analogPin++) {
    int sensor = analogRead(analogPin);
    dataString += String(sensor);
    if (analogPin < 2) {
      dataString += ",";
    }
  }

  File dataFile = SD.open("test.txt", FILE_WRITE);

  // if the file is available, write to it:
  if (dataFile) {
    dataFile.println(dataString);
    dataFile.close();
    // print to the serial port too:
    Serial.println(dataString);
  }
  // if the file isn't open, pop up an error:
  else {
    Serial.println("error opening file");
  }
}
