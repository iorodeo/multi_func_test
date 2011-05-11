import time
import scipy
import serial
import pylab

port = '/dev/ttyUSB1'
baudrate = 115200 


amp = 500
dt = 0.005
period  = 5.0
numPeriod = 5
N = int(period*numPeriod/dt)

t = scipy.arange(0,N)*dt
x = amp*scipy.sin(2*scipy.pi*t/period)
#pylab.plot(t,x)
#pylab.show()


ser = serial.Serial(port,baudrate)
time.sleep(2.0)

for val in x:
    val = int(val)
    ser.write('%d\r'%(val,))
    time.sleep(dt)

ser.write('0\r')
ser.close()


