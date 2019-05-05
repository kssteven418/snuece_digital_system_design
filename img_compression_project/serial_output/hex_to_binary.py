# -*- coding: utf8 -*-

filename="putty.log"
with open(filename, "rb") as f:
    line = f.readline()
    line = f.readline()
    print(line)

