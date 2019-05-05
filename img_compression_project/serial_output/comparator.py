filename1="file1.txt"
filename1=".txt"

lines1=[]
with open(filename1, "r") as f1:
    while True:
        line = f1.readline().strip()
        if not line:
            break
        lines1.append(line)

lines2=[]
with open(filename2, "r") as f2:
    while True:
        line = f2.readline().strip()
        if not line:
            break
        lines2.append(line)

max_len=max(len(lines1),len(lines2))
count=0
for i in range(max_len):
    check=(lines1[i]==lines2[i])
    if(check!=True):
        count=count+1
    print(lines1[i], lines2[i],check)
print("file1 len:",len(lines1))
print("file2 len:",len(lines2))
print("error rate",count/max_len*100)

