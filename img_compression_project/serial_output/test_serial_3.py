import serial,time
count=0

f=open("serialoutput.txt",'w')
total=''
with serial.Serial('COM1',115200) as s:  # open serial port
    #print(ser.name)         # check which port was really used
    #ser.write(b'hello')     # write a string
    #ser.close()             # close por
    while True:
        #a=("{:08b}".format(int(s.read().hex(),16)))
        #total=total+a
        #print(a)
        received = s.read()
        intnum = int(received.hex(), 16)
        indent = "{:08b}".format(intnum)
        print((indent))
        #print(indent,received,intnum)
        #print(indent[::-1])
        #print(indent[::-1],end='')
        #f.write(indent)
        #f.write("\n")
        #count = count + 1
        #print(format(8,result))
        #print(str(int(result,16)))
    #print(total)

#s=serial.Serial('COM1', 115200)
# print(ser.name)         # check which port was really used
# ser.write(b'hello')     # write a string
# ser.close()             # close port
#aa =s.read()
#print( aa)
    
    
    