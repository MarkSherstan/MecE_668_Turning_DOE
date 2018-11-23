# MecE_668_Turning_DOE

Design of experiments (DOE) for MecE 668. Testing the maximum instantaneous velocity an autonomous vehicle can travel in a turn before slipping.

## Registry Maps and Sensitivity Values for MPU-6050

Values retrieved from the MPU-6050 Register Map and Descriptions Revision 4.2 located [here](https://www.invensense.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf) and the Product Specification Revision 3.4 located [here](https://www.invensense.com/wp-content/uploads/2015/02/MPU-6000-Datasheet1.pdf).

| Accelerometer | Sensitivity   | Gyroscope     | Sensitivity   | Hexadecimal   |  Binary       |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| +/- 2g	      | 16384	        | +/- 250 deg/s | 131           | 0x00	        | 00000000      |
| +/- 4g	      | 8192 	        | +/- 500 deg/s | 65.5          | 0x08	        | 00001000      |
| +/- 8g        | 4096	        | +/- 1000 deg/s| 32.8          | 0x10	        | 00010000      |
| +/- 16g	      | 2048	        | +/- 2000 deg/s| 16.4          | 0x18	        | 00011000      |

## Arduino

* Accelerometer --> Outputs raw accelerometer values [acceleration in g force]
* Gyroscope --> Outputs raw gyroscope values [angular velocity in deg/s] and includes a calibration
* SDLog --> Logs accelerometer and gyroscope values to SD card
* Main --> Logs values to SD card and controls vehicle with a PWM signal

## MATLAB Data Acquisition and Processing

Raw data from sensor (.csv), videos (.mp4), and results (.mat) are included in sub folder titled 'data'. To add additional data or reanalyze existing data the following scripts and functions can be used:
* main --> Run this script to call all other MATLAB functions. Specify file names for reading here.
* scale --> Find the ratio of pixels to meters in the real domain.
* positionLogger --> Logs the x and y coordinates of the centroid of the tracking disk from a masking function.
* fileReader --> Reads the .csv file recorded by the Arduino.
* cleanData --> Applies filtfilt and a moving mean average to clean sensor data
* dataSlicer --> Matches the sensor and video data. Removes stationary data.
* circleFilter --> Finds the radius of the circle of the vehicle and determines stats to determine when vehicle slips.
* plotter --> Creates multiple graphs of all the data and outputs instantaneous velocity at slip.
* resultsMaster --> Run to see summary of all the instantaneous velocity results for each trial. Make sure to comment all plots in plotter function beforehand.

## Other

* Circuit_Layout --> Wiring layout using Fritzing
* Calibration_Blobs --> Print at "actual size" and do not scale! Used for scale.m.
