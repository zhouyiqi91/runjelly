#! /usr/bin/env python
import sys

with open(sys.argv[1],'r') as fasta:
	for line in fasta:
		line = line.strip("\n")
		if len(line) == 0:
			print "line without base!",line,name,index
			continue
		if line[0] == ">":
			name = line.strip(">")
			index = 0
		else:
			if index == 0:
				ingap = False
			for base in line:
				index += 1
				if base in "Nn" and ingap == False:
					ingap = True
					print name,index,
				if base not in "Nn" and ingap == True:
					print index-1
					ingap = False

				
