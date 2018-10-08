//Include I2C library
#include <Wire.h>

//Declaring some global variables
int gyro_x, gyro_y, gyro_z;
long gyro_x_cal, gyro_y_cal, gyro_z_cal;
long acc_x, acc_y, acc_z;
int temperature;

void setup() {
  Wire.begin();
  Serial.begin(57600);

  //Setup the registers of the MPU-6050 (500dfs / +/-8g) and start the gyro
  setup_mpu_6050_registers();

  Serial.println("MPU-6050 IMU Calibration");

  delay(1500);

  Serial.println("Calibrating gyro, place on level surface. Taking 5000 readings");

  delay(2000);

  for (int cal_int = 0; cal_int < 5000 ; cal_int ++){
    if(cal_int % 200 == 0)Serial.print(".");
    read_mpu_6050_data();
    gyro_x_cal += gyro_x;
    gyro_y_cal += gyro_y;
    gyro_z_cal += gyro_z;

    //Delay 3us to simulate the 250Hz program loop
    delay(3);
  }

  //Divide the gyro_xyz_cal variable by 5000 to get the average offset
  gyro_x_cal /= 5000;
  gyro_y_cal /= 5000;
  gyro_z_cal /= 5000;

  Serial.println(" Complete");

  Serial.println();
  Serial.println("Place this values in the main program");
  Serial.println();

  Serial.print("gyro_x_cal: ");
  Serial.println(gyro_x_cal);

  Serial.print("gyro_y_cal: ");
  Serial.println(gyro_y_cal);

  Serial.print("gyro_z_cal: ");
  Serial.println(gyro_z_cal);
}

void loop() {
}

void read_mpu_6050_data(){                                             //Subroutine for reading the raw gyro and accelerometer data
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x3B);                                                    //Send the requested starting register
  Wire.endTransmission();                                              //End the transmission
  Wire.requestFrom(0x68,14);                                           //Request 14 bytes from the MPU-6050

  while(Wire.available() < 14);                                        //Wait until all the bytes are received
  acc_x = Wire.read()<<8|Wire.read();                                  //Add the low and high byte to the acc_x variable
  acc_y = Wire.read()<<8|Wire.read();                                  //Add the low and high byte to the acc_y variable
  acc_z = Wire.read()<<8|Wire.read();                                  //Add the low and high byte to the acc_z variable
  temperature = Wire.read()<<8|Wire.read();                            //Add the low and high byte to the temperature variable
  gyro_x = Wire.read()<<8|Wire.read();                                 //Add the low and high byte to the gyro_x variable
  gyro_y = Wire.read()<<8|Wire.read();                                 //Add the low and high byte to the gyro_y variable
  gyro_z = Wire.read()<<8|Wire.read();                                 //Add the low and high byte to the gyro_z variable

}

void setup_mpu_6050_registers(){
  //Activate the MPU-6050
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x6B);                                                    //Send the requested starting register
  Wire.write(0x00);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
  //Configure the accelerometer (+/-8g)
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x1C);                                                    //Send the requested starting register
  Wire.write(0x10);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
  //Configure the gyro (500dps full scale)
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x1B);                                                    //Send the requested starting register
  Wire.write(0x08);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
}
