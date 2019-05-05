with open('serialoutput_trimmed.txt','w') as f1:
    with open('serialoutput.txt','r') as f:
        while True:
            line=f.readline().strip()
            f1.write(line)
            if not line:
                break
