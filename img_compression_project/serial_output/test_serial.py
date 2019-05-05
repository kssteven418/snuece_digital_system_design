import serial
count=0

f=open("serialoutput.txt",'w')

with serial.Serial('COM1',115200) as s:  # open serial port
    #print(ser.name)         # check which port was really used
    #ser.write(b'hello')     # write a string
    #ser.close()             # close port
    while True:
        try:
            result=s.read().strip()
            #print(result)
            a=int(result.hex(),16)
            b="{:08b}".format(a)
            print(b)
            f.write(b)
            f.write("\n")
            count=count+1
            if count%5==0:
                pass
                #print()

        except:
            pass
        #print(format(8,result))
        #print(str(int(result,16)))


#s=serial.Serial('COM1', 115200)
# print(ser.name)         # check which port was really used
# ser.write(b'hello')     # write a string
# ser.close()             # close port
#aa =s.read()
#print( aa)
    
    
    