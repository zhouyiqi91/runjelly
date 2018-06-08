#! /bin/bash
# $1=Protocol.xml $2=fastq_dir

for fastq in `ls $2|grep "\.fastq$" `
do
	size=`ls -l $2/$fastq | awk '{print $5}' `
	if [ $size -ne 0 ];then
		sed -i "10i\ \t\t<job>${fastq}</job>" $1
	fi
done


