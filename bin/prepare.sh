#! /bin/bash
#usage: prepare.sh input_bam_dir out_fastq_dir size opts

basepath=$(cd `dirname $0`; pwd)

if [ -f $basepath/bam2fastq.sh ];then
	bin_path=$basepath
else
	echo "use bam2fastq under current dir."
	bin_path=`pwd`
fi
export PATH=$bin_path:$PATH

opts=""
maxopts=$#
i=3
kong=" "
if [ $maxopts -lt 4 ];then
	echo "wrong input!"
	echo "usage: prepare.sh input_bam_dir out_fastq_dir size opts"
	exit
fi
while [ $i != $maxopts ]
do
    i=$((i+1))
    opts=${kong}${opts}${kong}${!i}
    
done

echo $opts

cd $2
for bam in ` ls $1|grep ".bam$" `
do
	echo "${bin_path}/bam2fastq.sh ${1}/${bam} $2 $3" > ./${bam}.sh
	qsub -cwd -V -l vf=${3}g,p=1 $opts ./${bam}.sh
done

