#! /bin/bash
# usage: stop.sh out_dir

if [ $1"x" == "x" ];then
	out_dir=`pwd`
else
	out_dir=$1
fi

while true;
do
	echo "Are you sure to stop longpb job under `pwd`?[y/n]"
	read bool
	if [ $bool"x" == "yx" ];then
		break
	elif [ $bool"x" == "nx" ];then
		exit
	fi
done

echo "killing job.."

ps -ef|grep "$out_dir"|grep -v "grep"|awk '{print $2}' | xargs kill -9 
if [ $? -ne 0 ];then
	echo "no jobs need to be killed!"
	echo
fi

