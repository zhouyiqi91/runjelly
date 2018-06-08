#! /usr/bin/env python
# gap_max.py <.fasta> <max gap size> 
import sys,re
from FileHandlers import FastaFile
from optparse import OptionParser

USAGE='''%prog <fasta file> [options]'''

def parseArgs():
    parser=OptionParser(USAGE)
    parser.add_option("-M","--max", dest="max", type="int",default=25,\
                       help="max output gap size")
    opts,args= parser.parse_args()
    if len(args) != 1:
        parser.error("no fasta file! use -h or --help for help")

    return opts,args[0]

if __name__ == '__main__':
    opts,ref=parseArgs()
    fasta=FastaFile(ref)
    gapRE=re.compile("[^Nn]([Nn]{1,%d})[^Nn]" % (opts.max))

    for entry in fasta.keys():
        gap_pos=[]
        seq=fasta[entry]
        for gap in gapRE.finditer(seq):
            
            print entry+"\t"+str(gap.start()+1)+"\t"+str(gap.end()-1)


            

