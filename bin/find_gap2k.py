#! /usr/bin/env python


import os
import sys
import re
import argparse
from FileHandlers import FastaFile


def help():
    print("""
    
Program: fina_gaps2k.py
         This script is used to generate information of gaps in a fasta file
		now it is used to generate 2000bp position around a gap


Version: v1.0
    
Usage:   python find_gap2k.py --seq scaffolds.fa --o ouput.file --bed 2000

Options:

         --help        help
         --seq         the sequence file
		 --bed		   cut number from scaf start and end	
         --o           the output file


Hope you have a good day ^_^!

""")
    sys.exit(2)

def find_gap(id, seq, extend):

    infor = ''
    index = 0
    i = 0
    pattern = re.compile(r'([Nn]+)')

    # start-edge for v4
    infor += id + '\t' + str( 0 ) + '\t' + str( int(extend) ) \
                     + '\t' + 'gap' + str(i) + '\t0\t' + '+' + '\n'

    while 1:
        tmp = pattern.search(seq, pos=index)
        if tmp:
            i+=1
            start1=tmp.start()+1-int(extend)
            end1=tmp.start()+len(tmp.group())+int(extend)
            if start1 <0:
                start1 = 0
            if end1 > len(seq):
                end1 = len(seq)-1
            infor += id + '\t' + str( start1 ) + '\t' + str( end1 ) \
                     + '\t' + 'gap' + str(i) + '\t0\t' + '+' + '\n'
            index = int(tmp.start()+len(tmp.group()))
        else:
            break

    # end-edge for v4
    i+=1
    start2=len(seq) - int(extend) + 1
    if start2 <0:
        start2 = 0
    infor += id + '\t' + str( start2 ) + '\t' + str( len(seq) ) \
                     + '\t' + 'gap' + str(i) + '\t0\t' + '+' + '\n'

    return infor
			

def main(argv=sys.argv):
    if len(argv) < 2 :
        help()


    else:
        parser = argparse.ArgumentParser(description='Paramerters to this script')
        parser.add_argument('--fasta', type=str, default=None)
        parser.add_argument('--o', type=str, default=None)
        parser.add_argument('--bed', type=int, default=None)
        args = parser.parse_args()

        fasta_dic = FastaFile(args.fasta)
        infor_out = open(args.o, 'w')

        for entry in sorted(fasta_dic.keys()):
            infor_out.write(find_gap(entry, fasta_dic[entry], args.bed))

        infor_out.close()


if __name__ == "__main__":
    main(sys.argv)

