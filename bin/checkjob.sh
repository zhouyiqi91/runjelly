#! /bin/bash
# check if previous jobs have been done
# $1=out dir
# $2= email address

i1=1s
i2=20s
basepath=$(cd `dirname $0`; pwd)
configpath=$basepath/../setup.config

cd $1
source *.cfg
while true;do
	if [ -f ref/gap_dist.out ];then
        a=`cat ref/gap_dist.out |grep -c "done"`
		b=1
        if [ $a -eq $b ];then
			echo "find gap done"
	        break
        fi
    fi
	sleep $i2
done

mkdir fastq
cd fastq


echo "submit minimap pick_reads jobs..."
ref_name=`basename $ref`
for fq in `ls $fastq_dir|grep "\.fastq$"`
do
    echo -e "source $configpath" > $fq.sh
    echo -e "find_reads.sh $fastq_dir/$fq ../ref/$ref_name.gap_dist.bed $ref $p" >> $fq.sh
    qsub -e $fq.err -o $fq.out -l vf=$vf,p=$p -V -cwd $opts $fq.sh
done

#pick
cd $1

while true;do
	number=`ls fastq/*.out 2>/dev/null|wc -l`
	if [ $number != 0 ];then
		count1=`ls fastq|grep -c ".*.out" `
		if [ $count1 != 0 ];then
			a=`cat fastq/*.out |grep -c "finished"`
			b=`ls -l fastq|grep -c ".fastq\.sh"`
			if [ $a -eq $b ];then
				break
			fi
		fi
	fi
    sleep $i2
done
echo "pick read done"
pro_job.sh $1/Protocol.xml $1/fastq
sleep $i1

#01
cd $1
sh ./scripts/01.*.sh
sleep $i1
while true;do
	if [ -f ref/setup*.err ];then 
		a=`cat ref/*.err |grep -c "Finished"`
		b=1
		if [ $a -eq $b ];then
			break
		fi
	fi
    sleep $i2
done
echo "01 done" >>run.log
sleep $i1

#02
sh ./scripts/02.*.sh
while true;do
	count2=` ls mapping|grep -c "mapping.*.err" `
	if [ $count2 != 0 ];then 
		a=`cat mapping/*.err |grep -c "tails mapped"`
		b=`ls -l mapping|grep -c "mapping_chunk.*.sh"`
		if [ $a -eq $b ];then
			break
		fi
	fi
	sleep $i2
done
echo "02 done" >>run.log
sleep $i1

#03
sh ./scripts/03.*.sh
while true;do
	count3=` ls support|grep -c "support.*.err" `
	if [ $count3 != 0 ];then
		a=`cat support/*.err |grep -c "Finished"`
		b=`cat support/support_chunk*.sh|grep -c "Support.py"`
		if [ $a -eq $b ];then
			break
		fi
	fi
	sleep $i2
done

echo "03 done" >>run.log
sleep $i1

#04
sh ./scripts/04.*.sh
while true;do
	count4=` ls assembly|grep -c "extraction.*.err" `
	if [ $count4 != 0 ];then
		a=`cat assembly/extraction_chunk*.err |grep -c "Finished"`
		b=`ls -l assembly|grep -c "extraction_chunk.*.sh"`
		if [ $a -eq $b ];then
			break
		fi
	fi
    sleep $i2
done
echo "04 done" >>run.log
sleep $i1

#05
sh ./scripts/05.*.sh

while true;do
	count5=` ls assembly|grep -c "assembly.*.err" `
	if [ $count5 != 0 ];then
		a1=`cat assembly/assembly_chunk*.err |grep -c "Finished"`
		a2=`cat assembly/assembly_chunk*.err |grep -c "Exiting"`
		a=$[a1+a2]
		b=`cat assembly/assembly_chunk*.sh|grep -c "Assembly.py"`
		if [ $a -eq $b ];then
			break
		fi
	fi
    sleep $i2
done
echo "05 done" >>run.log
sleep $i1

#06
sh ./scripts/06.*.sh
while true;do
    a=`ls|grep -c "jelly.out.fasta"`
    if [ $a -eq 1 ];then
        break
    fi
    sleep $i2
done
echo "06done" >> run.log
sleep $i1

#summary
pwd > result_summary.txt
while true;
do
	if [ -f jelly.out.fasta ];then 
		summarizeAssembly.py jelly.out.fasta >> result_summary.txt
		if [ ! $2"x" == "x" ];then
			cat result_summary.txt|mail -s " pbjelly done" $2
		fi
		break
	fi
	sleep 1m
done
echo "all job done "
