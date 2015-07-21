import serial
from time import sleep

def read_configfile():
    fin = open("config.txt","r")
    lines= tuple(fin)
    config = {}
    for line in lines:
       config[line.split(":")[0]]=line.split(":")[1]   
       fin.close()
    return config

config_arr=read_configfile()

def call_number(phnum):
    ser = serial.Serial('/dev/ttyUSB0',9600,timeout=1)
    ser.flush()
    print "Calling ...",phnum
    cmd="ATD"+str(phnum)+";\r"
    ser.write(cmd)
    sleep(30)
    ser.write('ATH\r')
    ser.close()

call_number("9666261963")
#print config_arr["phonenum"]+"dev"
#cust_num=str(config_arr["phonenum"].replace("\n",""));
#print cust_num + "dora"
#call_number(cust_num) 
