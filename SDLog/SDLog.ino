// Set up libraries, variables, and objects
#include <SPI.h>
#include <SD.h>
#include <Wire.h>
#define FILE_BASE_NAME "Data"

File myFile;

// SD Card
const int chipSelect = 4;
const uint8_t BASE_NAME_SIZE = sizeof(FILE_BASE_NAME) - 1;
char fileName[] = FILE_BASE_NAME "00.csv";

// Accelerometer
long acc_x, acc_y, acc_z;
double accel_x, accel_y, accel_z;
long scaleFactorAccel = 8192; // 2g --> 16384 , 4g --> 8192 , 8g --> 4096, 16g --> 2048

// Gyroscope --> Get offsets from calibrateGyro.ino
int gyro_x, gyro_y, gyro_z;
double rotation_x, rotation_y, rotation_z;
long scaleFactorGyro = 32.8; // 250 deg/s --> 131, 500 deg/s --> 65.5, 1000 deg/s --> 32.8, 2000 deg/s --> 16.4
long gyro_x_cal = -106;
long gyro_y_cal = 123;
long gyro_z_cal = -142;

// Other sensor variables
long loop_timer;
int temperature;


void setup() {
  Wire.begin();

  //Serial.begin(57600); // Only use for debugging.

  // Indicator LED. Displays on if error occurs
  pinMode(2, OUTPUT);

  // Setup the registers of the MPU-6050 and start up
  setup_mpu_6050_registers();

  // See if the card is present and can be initialized, then set up name
  if (!SD.begin(chipSelect)) {
    digitalWrite(2, HIGH);
    while (1);
  }

  while (SD.exists(fileName)) {
    if (fileName[BASE_NAME_SIZE + 1] != '9') {
        fileName[BASE_NAME_SIZE + 1]++;
    } else if (fileName[BASE_NAME_SIZE] != '9') {
        fileName[BASE_NAME_SIZE + 1] = '0';
        fileName[BASE_NAME_SIZE]++;
    } else {
        digitalWrite(2, HIGH);
        while (1);
      return;
    }
  }

  // Verify LED is off if all checks pass
  digitalWrite(2, LOW);

  // Reset the loop timer
  loop_timer = micros();
}


void loop() {
  // Read the raw acc data from MPU-6050
  read_mpu_6050_data();

  // Subtract the offset calibration value
  gyro_x -= gyro_x_cal;
  gyro_y -= gyro_y_cal;
  gyro_z -= gyro_z_cal;

  // Convert to instantaneous degrees per second
  rotation_x = (double)gyro_x / (double)scaleFactorGyro;
  rotation_y = (double)gyro_y / (double)scaleFactorGyro;
  rotation_z = (double)gyro_z / (double)scaleFactorGyro;

  // Convert to g force
  accel_x = (double)acc_x / (double)scaleFactorAccel;
  accel_y = (double)acc_y / (double)scaleFactorAccel;
  accel_z = (double)acc_z / (double)scaleFactorAccel;

  // Write data to file or indicate otherwise
  myFile = SD.open(fileName, FILE_WRITE);

  if (myFile) {
    myFile.print(loop_timer); myFile.print(",");
    myFile.print(accel_x, 7); myFile.print(",");
    myFile.print(accel_y, 7); myFile.print(",");
    myFile.print(accel_z, 7); myFile.print(",");
    myFile.print(rotation_x, 7); myFile.print(",");
    myFile.print(rotation_y, 7); myFile.print(",");
    myFile.println(rotation_z, 7);

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
  // Subroutine for reading the raw data
  Wire.beginTransmission(0x68);
  Wire.write(0x3B);
  Wire.endTransmission();
  Wire.requestFrom(0x68, 14);

  // Read data --> Temperature falls between acc and gyro registers
  while(Wire.available() < 14);
  acc_x = Wire.read() << 8 | Wire.read();
  acc_y = Wire.read() << 8 | Wire.read();
  acc_z = Wire.read() << 8 | Wire.read();
  temperature = Wire.read() <<8 | Wire.read();
  gyro_x = Wire.read()<<8 | Wire.read();
  gyro_y = Wire.read()<<8 | Wire.read();
  gyro_z = Wire.read()<<8 | Wire.read();
}


void setup_mpu_6050_registers() {
  // Activate the MPU-6050
  Wire.beginTransmission(0x68);
  Wire.write(0x6B);
  Wire.write(0x00);
  Wire.endTransmission();

  // Configure the accelerometer
  Wire.beginTransmission(0x68);
  Wire.write(0x1C);
  Wire.write(0x08); // 2g --> 0x00, 4g --> 0x08, 8g --> 0x10, 16g --> 0x18
  Wire.endTransmission();

  // Configure the gyro
  Wire.beginTransmission(0x68);
  Wire.write(0x1B);
  Wire.write(0x10); // 250 deg/s --> 0x00, 500 deg/s --> 0x08, 1000 deg/s --> 0x10, 2000 deg/s --> 0x18
  Wire.endTransmission();
}
