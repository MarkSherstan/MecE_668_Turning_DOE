////////////////////////////////////////////////////////////////////////////////
// Terms of use
////////////////////////////////////////////////////////////////////////////////
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

////////////////////////////////////////////////////////////////////////////////
// Pin Allocation
////////////////////////////////////////////////////////////////////////////////
// MPU 6050:
// VCC --> 5V
// GND --> GND
// SDA --> A4
// SCL --> A5
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Based on the following:
// http://www.brokking.net/imu.html
// https://medium.com/@kavindugimhanzoysa/lets-work-with-mpu6050-gy-521-part1-6db0d47a35e6
// http://www.techsystemsembedded.com/ascii_table.php
////////////////////////////////////////////////////////////////////////////////

//Include I2C and Servo library
#include <Wire.h>

//Declaring some global variables
int gyro_x, gyro_y, gyro_z;
long acc_x, acc_y, acc_z;
int temperature;
long loop_timer;
long scaleFactor = 16384;
double accel_x, accel_y, accel_z;


void setup() {
  Serial.begin(57600);

  //Setup the registers of the MPU-6050 (500dfs / +/-2g) and start up
  setup_mpu_6050_registers();

  //Reset the loop timer
  loop_timer = micros();
}


void loop(){
    //Read the raw acc data from MPU-6050
    read_mpu_6050_data();

    // Convert to g force
    accel_x = (double)acc_x / (double)scaleFactor;
    accel_y = (double)acc_y / (double)scaleFactor;
    accel_z = (double)acc_z / (double)scaleFactor;

    // Print / write data
    Serial.print("X: "); Serial.print(accel_x,10); Serial.print("  ");
    Serial.print("Y: "); Serial.print(accel_y,10);  Serial.print("  ");
    Serial.print("Z: "); Serial.println(accel_z,10);

    // Wait until the loop_timer reaches 4000us (250Hz) before starting the next loop
    while(micros() - loop_timer < 4000);
    loop_timer = micros();
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
  //Configure the accelerometer (+/-2g)
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x1C);                                                    //Send the requested starting register
  Wire.write(0x00);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
  //Configure the gyro (500dps full scale)
  Wire.beginTransmission(0x68);                                        //Start communicating with the MPU-6050
  Wire.write(0x1B);                                                    //Send the requested starting register
  Wire.write(0x08);                                                    //Set the requested starting register
  Wire.endTransmission();                                              //End the transmission
}

// 0x00 --> FS_SEL 0
// 0x08 --> FS_SEL 1
// 0x10 --> FS_SEL 2
// 0x?? --> FS_SEL 3
