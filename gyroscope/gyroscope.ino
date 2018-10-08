//Include I2C library and declare variables
#include <Wire.h>

int gyro_x, gyro_y, gyro_z;
long gyro_x_cal, gyro_y_cal, gyro_z_cal;
long loop_timer;
long scaleFactor = 65.5; // 250 deg/s --> 131, 500 deg/s --> 65.5, 1000 deg/s --> 32.8, 2000 deg/s --> 16.4
double rotation_x, rotation_y, rotation_z;


void setup() {
  Wire.begin();

  Serial.begin(57600);

  //Setup the registers of the MPU-6050 and start up
  setup_mpu_6050_registers();

  // Calculate offset and average values
  for (int cal_int = 0; cal_int < 2500 ; cal_int ++){
    read_mpu_6050_data();
    gyro_x_cal += gyro_x;
    gyro_y_cal += gyro_y;
    gyro_z_cal += gyro_z;
    delay(3);
  }

  gyro_x_cal /= 2500;
  gyro_y_cal /= 2500;
  gyro_z_cal /= 2500;

  //Reset the loop timer
  loop_timer = micros();
}


void loop(){
  // Read the raw gyro data from the MPU-6050
  read_mpu_6050_data();

  // Subtract the offset calibration value
  gyro_x -= gyro_x_cal;
  gyro_y -= gyro_y_cal;
  gyro_z -= gyro_z_cal;

  // Convert to instantaneous degrees per second
  rotation_x = (double)gyro_x / (double)scaleFactor;
  rotation_y = (double)gyro_y / (double)scaleFactor;
  rotation_z = (double)gyro_z / (double)scaleFactor;

  // Print / write data
  Serial.print(loop_timer); Serial.print(",");
  Serial.print(rotation_x, 7); Serial.print(",");
  Serial.print(rotation_y, 7); Serial.print(",");
  Serial.println(rotation_z, 7);

  // Wait until the loop_timer reaches 4000us (250Hz) before next loop
  while(micros() - loop_timer < 4000);
  loop_timer = micros();
}


void read_mpu_6050_data(){
  //Subroutine for reading the raw gyro data
  Wire.beginTransmission(0x68);
  Wire.write(0x43);
  Wire.endTransmission();
  Wire.requestFrom(0x68,6);

  // Read data
  while(Wire.available() < 6);
  gyro_x = Wire.read()<<8 | Wire.read();
  gyro_y = Wire.read()<<8 | Wire.read();
  gyro_z = Wire.read()<<8 | Wire.read();
}


void setup_mpu_6050_registers(){
  //Activate the MPU-6050
  Wire.beginTransmission(0x68);
  Wire.write(0x6B);
  Wire.write(0x00);
  Wire.endTransmission();

  //Configure the gyro
  Wire.beginTransmission(0x68);
  Wire.write(0x1B);
  Wire.write(0x08); // 250 deg/s --> 0x00, 500 deg/s --> 0x08, 1000 deg/s --> 0x10, 2000 deg/s --> 0x18
  Wire.endTransmission();
}
