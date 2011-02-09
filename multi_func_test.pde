// ----------------------------------------------------------------------------
// mult_func_test.pde
//
// Simple software for testing the nano_mult_func PCB. 
//
// Author: Will Dickson, IO Rodeo Inc.
// ----------------------------------------------------------------------------
#include <SPI.h>
#include "max1270.h"

#define CHIP_SELECT A0
#define SSTRB 2

MAX1270 analogIn = MAX1270(CHIP_SELECT,SSTRB);

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
    else {
        // Read a single sample from the MAX1270 IC
        int val;
        val = analogIn.sample(0);
        Serial.println(val,DEC);
        delay(1);
    }
}

