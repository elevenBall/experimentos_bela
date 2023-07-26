void setup() {
  Serial.begin(115200);
}

void loop() {
  Serial.print(analogRead(0));
  Serial.print("a");
  Serial.print(analogRead(1));
  Serial.print("b");
  
  delay(1);
}
