
lines=list()

with open("imem.mif", "r") as f:
    while True:
        line = f.readline().strip()
        if not line:
            break
        lines.append(line)
        #print(int(line,2))

newlist=list()
for i in range(32):
    for j in range(32):
        for k in range(16):
            addr=k
            if(4<=k<8):
                addr=11-k
            if(12<=k<16):
                addr=27-k
            localrow=int(addr/4)
            localcol=addr%4
            globaladdr=int(i * 128 *4 + j * 4 + localrow * 128 + localcol)
            #print(addr,localrow,localcol)
            #print(type(globaladdr),globaladdr)
            #print(i,j,k,globaladdr,lines[globaladdr],int(lines[globaladdr],2))
            #print(globaladdr)
            data=lines[globaladdr]
            data=int(data,2)
            #print(globaladdr,data)
            newlist.append(data)
            #print(i, j, k, globaladdr,data)


tosend=''
dpcm=newlist.copy()
q=newlist.copy()
r=newlist.copy()
result_list=newlist.copy()
queue=''
for i in range(len(newlist)):
    if i%16==0:
        dpcm[i]=newlist[i]
    else:
        diff=(newlist[i] - newlist[i - 1])
        if diff==0:
            dpcm[i]=0
        elif diff>0:
            dpcm[i]=2*diff
        else:
            dpcm[i]=2*(-diff)-1
    q[i]=int(dpcm[i]/4)
    r[i] = dpcm[i] % 4
    #print(q[i],r[i])
    result=''
    for j in range(q[i]):
        result=result+'0'
    result=result+'1'
    if r[i]==0:
        toappend='00'
    elif r[i]==1:
        toappend='01'
    elif r[i]==2:
        toappend='10'
    else:
        toappend='11'
    result=result+toappend
    #)
    result_list[i]=result
    #print(dpcm[i],q[i],r[i],result_list[i])
    #result=result+bin(r)[-2:]
    tosend=tosend+result
    #if(len(tosend)>=8):
    #    =tosend[0:7]


for i in range(len(newlist)):
    #print(q[i],",",r[i])
    pass
    #print("i",i, "data1",newlist[i],"data2",newlist[i-1],"dpcm",dpcm[i],"golomb",q[i],r[i],result_list[i])


#print(tosend)
count=0
for i in range(int(len(tosend)/8)):
    pass
    temp=tosend[8*i:8*i+8]
    print(temp[::-1])






