# MecE_668_Turning_DOE

Design of experiments (DOE) for MecE 668. Testing the maximum speed a car can travel before experiencing slipping.

## Registry Maps and Sensitivity Values for MPU-6050

Values retrieved from the MPU-6050 Register Map and Descriptions Revision 4.2 located [here](https://www.invensense.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf) and the Product Specification Revision 3.4 located [here](https://www.invensense.com/wp-content/uploads/2015/02/MPU-6000-Datasheet1.pdf).

| Accelerometer | Sensitivity   | Gyroscope     | Sensitivity   | Hexadecimal   |  Binary       |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| +/- 2g	      | 16384	        | 250 deg/s     | 131           | 0x00	        | 00000000      |
| +/- 4g	      | 8192 	        | 500 deg/s     | 65.5          | 0x08	        | 00001000      |
| +/- 8g        | 4096	        | 1000 deg/s    | 32.8          | 0x10	        | 00010000      |
| +/- 16g	      | 2048	        | 2000 deg/s    | 16.4          | 0x18	        | 00011000      |

## Arduino

* Accelerometer --> Outputs raw accelerometer values [acceleration in g force]
* Gyroscope --> Outputs raw gyroscope values [angular velocity in deg/s]
* SDLog --> Logs accelerometer and gyroscope values to SD card
* Main --> Logs values to SD card and controls vehicle

## MATLAB

* main --> Run this script to call all other MATLAB functions. Specify file names for reading here.
* scale --> Find the ratio of pixels to cm in the real domain.
* positionLogger --> Logs the x and y coordinates of the centroid of the tracking disk from masking function.
* createMask --> Filters for orange tracking disk.
* fileReader --> Reads the .csv file(s) recorded by the Arduino
* cleanUpFreq --> Perform FFT and builds a digital filter to smooth sensor data.
* dataSlicer --> Matches the sensor and video data. Removes stationary data.
* angleVelCalc --> Smooth centroid data and use it to calculate radius and angular velocity.
* plotter --> Creates multiple graphs of all the data

## Other

* Circuit_Layout --> Wiring layout using Fritzing
* Calibration_Blobs --> Print at "actual size". Do not scale! Used for scale.m. Ensure that calibration blobs are located at same height as tracking circle.

## To be Completed

* Add parallel computing toolbox to decrease computation time
* Get instantaneous velocity from w
* Place focus on w from sensor over computer vision
