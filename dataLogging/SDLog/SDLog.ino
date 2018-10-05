// Based off Tom Igoe SD card example https://www.arduino.cc/en/Tutorial/ReadWrite
// Shield uses pins 4, 11, 12, 13

#include <SPI.h>
#include <SD.h>
#include <Wire.h>

const int chipSelect = 4;
long acc_x, acc_y, acc_z;
long loop_timer;
long scaleFactor = 8192;
double accel_x, accel_y, accel_z;

File myFile;

void setup() {
  Serial.begin(57600);

  pinMode(2, OUTPUT);

  //Setup the registers of the MPU-6050 (500dfs / +/-2g) and start up
  setup_mpu_6050_registers();

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    digitalWrite(2, HIGH);
    while (1);
  }

  digitalWrite(2, LOW);

  //Reset the loop timer
  loop_timer = micros();
}


void loop() {
  //Read the raw acc data from MPU-6050
  read_mpu_6050_data();

  // Convert to g force
  accel_x = (double)acc_x / (double)scaleFactor;
  accel_y = (double)acc_y / (double)scaleFactor;
  accel_z = (double)acc_z / (double)scaleFactor;


  myFile = SD.open("test.txt", FILE_WRITE);


  if (myFile) {
    myFile.print(loop_timer); myFile.print(",");
    myFile.print(accel_x, 7); myFile.print(",");
    myFile.print(accel_y, 7); myFile.print(",");
    myFile.println(accel_z, 7);

    myFile.close();

    digitalWrite(2, LOW);
  } else {
    digitalWrite(2, HIGH);
  }

  // Wait until the loop_timer reaches 4000us (250Hz) before starting the next loop
  while (micros() - loop_timer < 4000);
  loop_timer = micros();
}


void read_mpu_6050_data() {
  //Subroutine for reading the raw accelerometer data
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x3B);                                                    //Send the requested starting register
  Wire.endTransmission();                                              //End the transmission
  Wire.requestFrom(0x68, 6);                                           //Request 6 bytes from the MPU-6050

  // Read data
  while (Wire.available() < 6);                                        //Wait until all the bytes are received
  acc_x = Wire.read() << 8 | Wire.read();                              //Add the low and high byte to the acc_x variable
  acc_y = Wire.read() << 8 | Wire.read();                              //Add the low and high byte to the acc_y variable
  acc_z = Wire.read() << 8 | Wire.read();                              //Add the low and high byte to the acc_z variable
}


void setup_mpu_6050_registers() {
  //Activate the MPU-6050
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x6B);                                                    //Send the requested starting register
  Wire.write(0x00);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission

  //Configure the accelerometer (+/-4g)
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x1C);                                                    //Send the requested starting register
  Wire.write(0x08);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
}
