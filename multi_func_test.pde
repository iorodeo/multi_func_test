// ----------------------------------------------------------------------------
// mult_func_test.pde
//
// Simple software for testing the nano_mult_func PCB. 
//
// Author: Will Dickson, IO Rodeo Inc.
// ----------------------------------------------------------------------------
#include <SPI.h>
#include "max1270.h"
#include "mcp4822.h"
#include "mcp4261.h"

#define AIN_CS A0
#define AIN_SSTRB 2

#define AOUT_CS A1
#define AOUT_LDAC A3
#define DIGIPOT_CS A2

MAX1270 analogIn = MAX1270(AIN_CS,AIN_SSTRB);
MCP4822 analogOut = MCP4822(AOUT_CS,AOUT_LDAC);
MCP4261 digiPot = MCP4261(DIGIPOT_CS);

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

}

void loop() {


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
        static int cnt=0;
        Serial.print("cnt = ");
        Serial.println(cnt,DEC);
        //analogOut.setValue_A(cnt);
        //analogOut.setValue_B(cnt);
        analogOut.setValue_AB(cnt,cnt);
        //analogOut.setValue_A(cnt);
        //analogOut.off_B();
        cnt += 20;
        if (cnt > 4095) {
            cnt = 0;
        }
    }

    if (0) {
        int val;
        val = analogIn.sample(0);
        analogOut.setValue_A(val);
    }

    if (1) {
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
}

