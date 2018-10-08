# MecE_668_Turning_DOE

Design of experiments (DOE) for MecE 668. Testing the maximum speed a car can travel before experiencing slipping.

# Registry Maps and Sensitivity Values for MPU6050

Values retrieved from the MPU-6050 Register Map and Descriptions Revision 4.2 located [here](https://www.invensense.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf) and the Product Specification Revision 3.4 located [here](https://www.invensense.com/wp-content/uploads/2015/02/MPU-6000-Datasheet1.pdf).

Accel       Sensitivity   Gyroscope      Sensitivity    Hexadecimal     Binary
--------------------------------------------------------------------------------
+/- 2g	    2048	        250 deg/s      131            0x00	          00000000
+/- 4g	    4096	        500 deg/s      65.5           0x08	          00001000
+/- 8g      8192	        1000 deg/s     32.8           0x10	          00010000
+/- 16g	    16384	        2000 deg/s     16.4           0x18	          00011000
