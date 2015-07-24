import serial
from random import randint
from time import sleep
from threading import Thread
import threading

resume=threading.Event()
   

def read_configfile():
    fin = open("config.txt","r")
    lines= tuple(fin)
    config = {}
    for line in lines:
       config[line.split(":")[0]]=line.split(":")[1]   
       fin.close()
    return config

config_arr=read_configfile()
    
def weight_read():
    global config_arr
    global resume
    while True :
     try:
        ser=serial.Serial('/dev/ttyAMA0',9600,timeout=1)    
        ser.flush()
        num=ser.inWaiting()
        if(num != 0):
            s=ser.read(num)
            print "weight",s
            weight= s.split(" Kg.")[0]
	    #print weight
            if(float(weight) < 4):
                resume.clear()
                #call_number(config_arr["phonenum"]) 
                call_number("9666261963")                              
                print "calling"            
        ser.close()
     except:
        print "...."

def call_number(phnum):
   try: 
    global resume
    ser = serial.Serial('/dev/ttyUSB0',9600,timeout=1)
    ser.flush()
    print "Calling ...",phnum
    cmd="ATD"+str(phnum)+";\r"
    ser.write(cmd)
    sleep(15)
    ser.write('ATH\r')
    ser.close()
   except:
    print "call_error"    
   resume.set()
   




try:
    resume.set()   
    wt_thread=Thread(target = weight_read);
    wt_thread.start()
    wt_thread.join()   
except:
    print " thread Error"
    

    
