#! /bin/bash
# $1=.fastq
# $2=gap.bed
# $3=ref
# $4=proc

outname=`basename $1 .fastq`
#minimap
minimap2 --secondary=no -t $4 -x map-pb $3 $1 >$outname.paf
#pad to bed
awk ' {OFS="\t"} {print $6,$8,$9,$1}' $outname.paf > $outname.bed
#get reads
intersectBed -a $outname.bed -b $2 -wo > $outname.pick.bed
awk '{print $4}' $outname.pick.bed|sort|uniq  >$outname.name.txt
pick_reads.py $outname.name.txt $1 >$outname.pick.fastq

echo "finished"

#clean
rm $outname.pick.bed
rm $outname.name.txt


