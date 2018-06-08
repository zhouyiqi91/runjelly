#! /bin/bash
# convert bam to mecat input_fastq
# usage: bam2fastq.sh *.bam output_dir size(e.g. 1 means 1G)

file=$(basename $1 .bam)
samtools view $1|awk '{print "@"$1;print $10;print "+";print $11}' > $2/${file}.fastq
#divide
s=` ls -l $2/${file}.fastq|awk '{print $5}' `
size=$((1024*1024*1024*$3))
N=$((s/size+1))
fastqDivide.py $2/${file}.fastq $N
rm $2/${file}.fastq

