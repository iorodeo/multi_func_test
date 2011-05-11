import serial
from matplotlib import pylab

port = '/dev/ttyUSB1'
baudrate = 115200 


ser = serial.Serial(port,baudrate)
ser.flushInput()

numSample = 500
cnt = 0
cntList = []
analogOut = []
analogIn = []
while 1:

    line = ser.readline()
    line = line.split()
    try:
        outValue = float(line[0])
        inValue = float(line[1])
    except:
        continue
    cnt += 1
    cntList.append(cnt)
    analogOut.append(outValue)
    analogIn.append(inValue)
    print cnt, outValue, inValue
    if cnt == numSample:
        break


#pylab.plot(cntList,analogIn,'.')
pylab.hist(analogIn)
pylab.show()
