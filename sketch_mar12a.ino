#include "Wire.h"

#define EEPROM_I2C_ADDRESS 0x50

void setup() 
{
  Wire.begin();
  Serial.begin(9600);

  int address = 0;
  byte val = 110;
  int numBytes = 64;
  /*
  for(int i = address; i < numBytes; i ++){
  Serial.print("Writing ");
  Serial.println(val); 
  writeAddress(i, val); 
  }*/
  for(int i = address; i < numBytes; i++){
  Serial.print("The returned value is ");
  byte readVal = readAddress(i);
  Serial.println(readVal);
  }

}

void loop() 
{

}

void writeAddress(int address, byte val)
{
  Wire.beginTransmission(EEPROM_I2C_ADDRESS);
  Wire.write((int)(address >> 8));   // MSB
  Wire.write((int)(address & 0xFF)); // LSB
  
   
  Wire.write(val);
  Wire.endTransmission();

  delay(5);
}

byte readAddress(int address)
{
  byte rData = 0xFF;
  
  Wire.beginTransmission(EEPROM_I2C_ADDRESS);
  
  Wire.write((int)(address >> 8));   // MSB
  Wire.write((int)(address & 0xFF)); // LSB
  Wire.endTransmission();  


  Wire.requestFrom(EEPROM_I2C_ADDRESS, 1);  

  rData =  Wire.read();

  return rData;
}
