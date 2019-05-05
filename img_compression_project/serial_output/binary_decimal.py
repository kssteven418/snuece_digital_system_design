

filename='imem.mif'
lines=list()

outputfile=filename.split('.')[0]+"_de"+".mif"
f2=open(outputfile,'w')

with open(filename, "r") as f:
    while True:
        line = f.readline().strip()
        if not line:
            break
        lines.append(line)
        f2.write(str(int(line,2))+"\n")

f2.close()
