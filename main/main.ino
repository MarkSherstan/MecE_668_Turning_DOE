#include <Servo.h>
Servo esc;
int val;
int mapval;

void setup(){
  Serial.begin(9600);
  esc.attach(9);
  esc.writeMicroseconds(1000);
  pinMode(13, OUTPUT);
}

void loop(){
  val = analogRead(A0);
  mapval = map(val, 0, 1023,1000,2000);
  esc.writeMicroseconds(mapval);

  if (val > 0){
    digitalWrite(13, HIGH);
  } else{
    digitalWrite(13, LOW);
  }

  Serial.println(mapval);
}
