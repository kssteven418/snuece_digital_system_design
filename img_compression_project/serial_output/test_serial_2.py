import serial
count=0

f=open("serialoutput.txt",'w')

with serial.Serial('COM1',115200) as s:  # open serial port
    #print(ser.name)         # check which port was really used
    #ser.write(b'hello')     # write a string
    #ser.close()             # close port

    while True:
        received = s.read()
        intnum = int(received.hex(), 16)
        indent = "{:08b}".format(intnum)
        #indent[::-1])
        print(indent,received,intnum)
        f.write(indent[::-1])
        #f.write("\n")
        count = count + 1
        #print(format(8,result))
        #print(str(int(result,16)))


#s=serial.Serial('COM1', 115200)
# print(ser.name)         # check which port was really used
# ser.write(b'hello')     # write a string
# ser.close()             # close port
#aa =s.read()
#print( aa)
    
    
    