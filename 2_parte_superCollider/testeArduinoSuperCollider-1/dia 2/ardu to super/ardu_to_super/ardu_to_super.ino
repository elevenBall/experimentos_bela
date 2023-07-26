int pot0 = 0;
int pot1 = 0;

void setup() {
  Serial.begin(9600);
}



void loop() {
  // our readings in arduino
  pot0 = analogRead(0);
  delay(1);  // delay in between analog reads for stability
  pot1 = analogRead(1);
  delay(1);
  // below will serial print an array of value
  Serial.print(pot0);
  Serial.print(",");     // adding comma!
  Serial.println(pot1);  // finally, break line!
  delay(1);
}
