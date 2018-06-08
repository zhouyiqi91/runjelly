#! /bin/bash
# paf2bed.sh .paf 
bedname=`basename $1 .paf`
awk ' {OFS="\t"} {print $6,$8,$9,$1}' $1 > $bedname.bed 
