#! /bin/bash
# stop the job and rm all files except example.cfg

bin_path=$(cd `dirname $0`; pwd) 
sh $bin_path/stop.sh
a=`ls |grep -c "cfg$"`
if [ $a == 0 ];then
    echo "no cfg file! exit."
    exit
fi
while true
do
        echo "removing all file?[y/n]"
        read bool
        if [ $bool"x" == "yx" ];then
                break
        elif [ $bool"x" == "nx" ];then
                exit
        fi
done

echo "removing files..."
ls|grep -v ".*\.cfg$"|xargs rm -r

