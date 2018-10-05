// Based off Tom Igoe SD card example https://www.arduino.cc/en/Tutorial/ReadWrite
// Shield uses pins 4, 11, 12, 13

#include <SPI.h>
#include <SD.h>
const int chipSelect = 4;
File myFile;

void setup() {
  Serial.begin(57600);

  pinMode(2, OUTPUT);

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    digitalWrite(2, HIGH);
    while (1);
  }

  digitalWrite(2, LOW);
}


void loop() {
  myFile = SD.open("test.txt", FILE_WRITE);

  int sensorA0 = analogRead(A0);
  int sensorA1 = analogRead(A1);

  if (myFile) {
    myFile.print(sensorA0); myFile.print(",");
    myFile.println(sensorA1);

    myFile.close();

    digitalWrite(2, LOW);
  } else {
    digitalWrite(2, HIGH);
  }
}
