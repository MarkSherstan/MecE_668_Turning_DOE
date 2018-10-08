//Include I2C library
#include <Wire.h>

int gyro_x, gyro_y, gyro_z;
long gyro_x_cal, gyro_y_cal, gyro_z_cal;
long loop_timer;
// Correct Variable??
long scaleFactor = 65.5; // 250 deg/s --> 131, 500 deg/s --> 65.5, 1000 deg/s --> 32.8, 2000 deg/s --> 16.4
double acceleration_x, acceleration_y, acceleration_z;


void setup() {
  Wire.begin();

  Serial.begin(57600);

  //Setup the registers of the MPU-6050 and start up
  setup_mpu_6050_registers();

  // Calculate offset and average values
  for (int cal_int = 0; cal_int < 2000 ; cal_int ++){
    read_mpu_6050_data();
    gyro_x_cal += gyro_x;
    gyro_y_cal += gyro_y;
    gyro_z_cal += gyro_z;
    delay(3);
  }

  gyro_x_cal /= 2000;
  gyro_y_cal /= 2000;
  gyro_z_cal /= 2000;

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

  //Gyro angle calculations
  //0.0000611 = 1 / (250Hz / 65.5)
  angle_pitch += gyro_x * 0.0000611;
  angle_roll += gyro_y * 0.0000611;

  //0.000001066 = 0.0000611 * (3.142(PI) / 180degr) The Arduino sin function is in radians
  angle_pitch += angle_roll * sin(gyro_z * 0.000001066);
  angle_roll -= angle_pitch * sin(gyro_z * 0.000001066);

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
