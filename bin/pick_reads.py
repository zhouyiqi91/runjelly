#! /usr/bin/env python

import sys
nametxt=sys.argv[1]
fastq=sys.argv[2]
outname=fastq.split("/")[-1].split(".")[0]+".picked.fastq"

dic = {}
with open (fastq,'r') as fq:
	for line in fq:
		if line[0] == "@":
			a=line.strip("\n").split(" ")
			index = a[0]+"\n"
			dic[index] = ""
		elif line[0] in "ATCGatcgNn":
			dic[index] += line
		

with open (nametxt,'r') as name:
	for line in name:
		line = "@"+line
		print(line),
		print(dic[line]),
		print("+")
		len1 = len(dic[line]) - 1 #"\n"
		qual = "!"*len1
		print(qual)

		
		
