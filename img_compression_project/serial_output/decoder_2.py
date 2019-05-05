
lines=list()

with open("imem.mif", "r") as f:
    while True:
        line = f.readline().strip()
        if not line:
            break
        lines.append(int(line,2))
        #print(int(line,2))

def addr_trans(i,j,k,mode):
    if mode==0:
        if (4 <= k < 8):
            k = 11 - k
        if (12 <= k < 16):
            k = 27 - k
        localrow = int(k / 4)
        localcol = k % 4
        globaladdr = int(i * 128 * 4 + j * 4 + localrow * 128 + localcol)
    elif mode==1:
        k = int(k / 4) + 4 * (k % 4)
        if 4 <= k < 8:
            k = 14 - k
        if 12 <= k < 16:
            k = 18 - k
        localrow = int(k / 4)
        localcol = k % 4
        globaladdr = int(i * 128 * 4 + j * 4 + localrow * 128 + localcol)
    return globaladdr





def dpcm(data1,data2,mode):
    source=int()
    if mode=="first":
        source=data
    elif mode=="other":
        diff = (data1 - data2)
        if diff == 0:
            source=0
        elif diff > 0:
            source= 2 * diff
        else:
            source= 2 * (-diff) - 1
    q = int(source / 4)
    r = source% 4
    return q,r

def golomb(q,r):
    for j in range(q):
        result = result + '0'
    result = result + '1'
    if r[i] == 0:
        toappend = '00'
    elif r[i] == 1:
        toappend = '01'
    elif r[i] == 2:
        toappend = '10'
    else:
        toappend = '11'
    result = result + toappend
    return result
    # )
    result_list[i] = result
    # print(dpcm[i],q[i],r[i],result_list[i])
    # result=result+bin(r)[-2:]
    tosend = tosend + result
    # if(len(tosend)>=8):
    #    =tosend[0:7]



tosend=''
for i in range(32):
    for j in range(32):
        dpcm1=0
        dpcm2=0
        tosend1=''
        tosend2=''
        for k in range(16):
            #mode1
            data1 = lines[addr_trans(i, j, k, 0)]
            data2 = lines[addr_trans(i, j, k - 1, 0)]
            if k==0:
                tosend1=tosend1+"{:08b}".format(data1)
            else:
                q, r = dpcm(data1, data2, "other")
                for m in range(q):
                    tosend1 = tosend1 + '0'
                tosend1 = tosend1 + '1'
                tosend1 = tosend1 + "{:02b}".format(r)
                dpcm1=dpcm1+q

            #mode2
            data1 = lines[addr_trans(i, j, k, 1)]
            data2 = lines[addr_trans(i, j, k - 1, 1)]
            if k==0:
                tosend2=tosend2+"{:08b}".format(data1)
            else:
                q, r = dpcm(data1, data2, "other")
                for m in range(q):
                    tosend2 = tosend2 + '0'
                tosend2 = tosend2 + '1'
                tosend2 = tosend2 + "{:02b}".format(r)
                dpcm2=dpcm2+q
        if dpcm1<dpcm2:
            tosend=tosend+tosend1
        else:
            tosend = tosend + tosend2

print(len(tosend))





