// ----------------------------------------------------------------------------
// mult_func_test.pde
//
// Simple software for testing the nano_mult_func PCB. 
//
// Author: Will Dickson, IO Rodeo Inc.
// ----------------------------------------------------------------------------
#include <SPI.h>
#include <Streaming.h>
#include "max1270.h"
#include "mcp4822.h"
#include "mcp4261.h"
#include "dynamics.h"
#include "Messenger.h"

#define AIN_CS A0
#define AIN_SSTRB 2
#define AOUT_CS A1
#define AOUT_LDAC A3
#define DIGIPOT_CS A2
#define SSR0 7
#define SSR1 10

MAX1270 analogIn = MAX1270(AIN_CS,AIN_SSTRB);
MCP4822 analogOut = MCP4822(AOUT_CS,AOUT_LDAC);
MCP4261 digiPot = MCP4261(DIGIPOT_CS);
Dynamics dynamics = Dynamics();
Messenger message = Messenger(); 

void setup() {

    // Setup serial and SPI communications
    Serial.begin(115200);
    SPI.setDataMode(SPI_MODE0);
    SPI.setBitOrder(MSBFIRST);
    SPI.setClockDivider(SPI_CLOCK_DIV8);
    SPI.begin();

    // Configure analog inputs
    analogIn.setBipolar();
    analogIn.setRange10V();

    // Configure analog outputs
    analogOut.setGain2X_AB();

    digiPot.initialize();
    //digiPot.setWiper0_NonVolatile(128);
    //delay(100);
    //digiPot.setWiper1_NonVolatile(128);

    dynamics.setMass(5.0);
    dynamics.setDt(0.01);
    dynamics.setDamping(1.0);

    message.attach(messageCompleted);
    pinMode(SSR0,OUTPUT);
    pinMode(SSR1,OUTPUT);
    analogOut.setValue_A(0);
    digitalWrite(SSR0,LOW);
    digitalWrite(SSR1,LOW);

}

// Define messenger function
void messageCompleted() {
    int value;
    while ( message.available() ) {
        value = message.readInt();
        setMotorVel(value);
    }
}

void setMotorVel(int value) {
    int absValue;
    if (value >= 0) {
        Serial.print("dir +, value = ");
        digitalWrite(SSR1,LOW);
        digitalWrite(SSR0,HIGH);
    }
    else {
        Serial.print("dir -, value = ");
        digitalWrite(SSR0,LOW);
        digitalWrite(SSR1,HIGH);
    }
    absValue = abs(value);
    Serial.println(absValue,DEC);
    analogOut.setValue_A(absValue);

}

void loop() {

    if (1) {
        while ( Serial.available() ) message.process( Serial.read() );
    }


    if (0) {
        // Read all samples from the MAX1270 IC
        int values[MAX1270_NUMCHAN];
        analogIn.sampleAll(values);
        for (int i=0; i<MAX1270_NUMCHAN; i++) {
            Serial.print(values[i],DEC);
            Serial.print(", ");
        }
        Serial.println();
        delay(1);
    }

    if (0)  {
        // Read a single sample from the MAX1270 IC
        int val;
        val = analogIn.sample(0);
        Serial.println(val,DEC);
        delay(1);
    }

    if (0) { 
        int val;
        static int cnt=0;
        Serial.print(cnt,DEC);
        Serial.print(" ");
        //analogOut.setValue_A(cnt);
        analogOut.setValue_A(cnt);
        delay(10);
        val = analogIn.sample(0);
        Serial.println(val,DEC);
        //analogOut.setValue_B(cnt);
        //analogOut.setValue_AB(cnt,cnt);
        //analogOut.setValue_A(cnt);
        //analogOut.off_B();
        cnt += 1;
        if (cnt > 3900) {
            cnt = 0;
        }
    }

    if (0) {
        int val;
        val = analogIn.sample(0);
        analogOut.setValue_A(val);
    }

    if (0) {
        static int cnt=10;
        //digiPot.setWiper0(cnt);
        //digiPot.setWiper1(256-cnt);
        cnt += 1;
        if (cnt > 246) {
            cnt = 10;
        }
        //delay(10);
        if (cnt < 100) {
            digiPot.incrWiper0();
            Serial.println("incr");
        } 
        else {
            digiPot.decrWiper0();
            Serial.println("decr");
        }
        delay(100);
    }

    if (0) {
        float force;
        float vel;
        float pos;
        int output;

        force = analogIn.sampleVolts(0);
        dynamics.update(force);
        vel = dynamics.getVelocity();
        pos = dynamics.getPosition();
        output = (int) 300*vel;
        analogOut.setValue_A(output);
        Serial << "vel: " << vel << ", pos: " << pos << ", output: " << output << endl;
        delay(10);

    }
}

