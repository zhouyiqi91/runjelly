#! /bin/bash
# 2018/04/20
# pbjelly main
# usage:runjelly.sh example.cfg 


#read cfg file
if [ ! -f "$1" ];then
	echo "cfg file do not exist!"
	echo "usage: runjelly.sh example.cfg"
	exit
fi
source $1

if [ $maxjob"x" == "x" ];then
        maxjob=200
fi
out_dir=`pwd`
cd $out_dir
jobnumber=`ps -ef|grep "$out_dir"|grep -v "grep"|wc -l`
if [ $jobnumber -ne 0 ];then
	echo "checkjob.sh is still running in background mode!"
	echo "use:"
	echo "  sh path_to_bin_dir/cleanup.sh ( to kill checkjob.sh and rm other files)"
	echo "then you can rerun the job"
	exit
fi

echo "copy reference and generate scripts..."
basepath=$(cd `dirname $0`; pwd)
configpath=$basepath/../setup.config
source $configpath
mkdir ref
#make sure ref<4G
max_size=$((1024*1024*1024*4))
ref_size=`ls -l $ref | awk '{ print $5 }'`
if [ $ref_size -gt $max_size ];then
	echo "reference size >4G! please use fasta-splitter.pl to split fasta."
	exit
fi
cp $ref ref
ref_name=`ls ref`


#gap.bed
cd ref
echo "submit find_gap job..."
if [ ! -n "$dist" ];then
	dist=2000
fi

echo -e "source $configpath" >gap_dist.sh
echo -e "find_gap2k.py --fasta $ref --o $ref_name.gap_dist.bed --bed $dist" >> gap_dist.sh
echo -e "echo done" >>gap_dist.sh
qsub -e gap_dist.err -o gap_dist.out -l vf=2g,p=1 -V -cwd $opts ./gap_dist.sh
cd ..

fastq_dir=$out_dir/fastq

#log

id >>$basepath/user.log
date >>$basepath/user.log

#generate Protocol.xml
echo -e "<jellyProtocol>" > $out_dir/Protocol.xml
echo -e "\t<reference>$out_dir/ref/$ref_name</reference>">> $out_dir/Protocol.xml
echo -e "\t<outputDir>$out_dir</outputDir>" >>$out_dir/Protocol.xml
echo -e "\t<blasr>$blasr --nproc $p</blasr>" >>$out_dir/Protocol.xml
echo -e "\t<cluster>" >>$out_dir/Protocol.xml
echo -e "\t\t<command notes=\"For PBS/Moab\">echo '\${CMD}' | qsub -N \"\${JOBNAME}\" -o \${STDOUT} -e \${STDERR} -l vf=$vf,p=$p $opts -cwd -V</command>" >>$out_dir/Protocol.xml
echo -e "\t\t<nJobs>$maxjob</nJobs>" >>$out_dir/Protocol.xml
echo -e "\t</cluster>" >>$out_dir/Protocol.xml
echo -e "\t<input baseDir=\"$fastq_dir\">" >>$out_dir/Protocol.xml
echo -e "\t</input>" >>$out_dir/Protocol.xml
echo -e "</jellyProtocol>" >>$out_dir/Protocol.xml

#pro_job.sh $out_dir/Protocol.xml $fastq_dir

# generate script 01-06,stop_jelly.sh 
mkdir -p $out_dir/scripts
cd $out_dir/scripts
pb_script.sh $out_dir/Protocol.xml $p $configpath
echo -e "$basepath/stop.sh $out_dir" > stop_jelly.sh

cd $out_dir
echo "Pipeline will running in background mode"
echo "If you need to stop the pipeline, run:"
echo "	sh ./scripts/stop_jelly.sh"
echo "(However,you need to qdel all the running jobs on cluster manually) "


nohup checkjob.sh $out_dir $email &

