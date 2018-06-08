# usage: fastq_split.sh input_fastq_dir output_fastq_dir N 
# N:number of splits to create
# !/bin/bash

if [ "$1" == "" -o "$1" == "-h" ];then
	cat $0|head -n 2
	exit
fi

if [ ! -d $2 ];then
	mkdir -p $2
fi

cd $2
cat $1/*.fastq > all.fastq
fastqDivide.py all.fastq $3
rm all.fastq

	
