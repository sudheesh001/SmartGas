import serial
from random import randint
from time import sleep
from threading import Thread

def weight_read():
    global config_arr
    while True :
     try:
        ser=serial.Serial('/dev/ttyAMA0',9600,timeout=1)    
        ser.flush()
        num=ser.inWaiting()
        if(num != 0):
            s=ser.read(num)
            print s
            weight= s.split(" Kg.")[0]
	    #print weight
            if(float(weight) < 4):
                #call_number(config_arr["phonenum"])
                print "calling"            
        ser.close()
     except:
        print "Weight read error"

try:
    wt_thread=Thread(target = weight_read);
    wt_thread.start()
    wt_thread.join()   
except:
    print " thread creation Error"





 
      


