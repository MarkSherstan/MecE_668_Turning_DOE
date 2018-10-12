//Include I2C library and declare variables
#include <Wire.h>

long acc_x, acc_y, acc_z;
long loop_timer;
long scaleFactor = 8192; // 2g --> 16384 , 4g --> 8192 , 8g --> 4096, 16g --> 2048
double accel_x, accel_y, accel_z;


void setup() {
  Wire.begin();

  Serial.begin(57600);

  //Setup the registers of the MPU-6050 and start up
  setup_mpu_6050_registers();

  //Reset the loop timer
  loop_timer = micros();
}


void loop() {
  // Read the raw acc data from MPU-6050
  read_mpu_6050_data();

  // Convert to g force
  accel_x = (double)acc_x / (double)scaleFactor;
  accel_y = (double)acc_y / (double)scaleFactor;
  accel_z = (double)acc_z / (double)scaleFactor;

  // Print / write data
  Serial.print(loop_timer); Serial.print(",");
  Serial.print(accel_x, 7); Serial.print(",");
  Serial.print(accel_y, 7); Serial.print(",");
  Serial.println(accel_z, 7);

  // Wait until the loop_timer reaches 4000us (250Hz) before next loop
  while (micros() - loop_timer < 4000);
  loop_timer = micros();
}


void read_mpu_6050_data() {
  //Subroutine for reading the raw accelerometer data
  Wire.beginTransmission(0x68);
  Wire.write(0x3B);
  Wire.endTransmission();
  Wire.requestFrom(0x68, 6);

  // Read data
  while (Wire.available() < 6);
  acc_x = Wire.read() << 8 | Wire.read();
  acc_y = Wire.read() << 8 | Wire.read();
  acc_z = Wire.read() << 8 | Wire.read();
}


void setup_mpu_6050_registers() {
  //Activate the MPU-6050
  Wire.beginTransmission(0x68);
  Wire.write(0x6B);
  Wire.write(0x00);
  Wire.endTransmission();

  //Configure the accelerometer
  Wire.beginTransmission(0x68);
  Wire.write(0x1C);
  Wire.write(0x08); // 2g --> 0x00, 4g --> 0x08, 8g --> 0x10, 16g --> 0x18
  Wire.endTransmission();
}
