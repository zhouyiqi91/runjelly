#! /bin/bash
#author zhouyiqi 2018/02/05
#generate pbjelly script
#usage:pb_script.sh out_dir p configpath

echo  "source $3" > 01.setup.sh
echo  "source $3" > 02.mapping.sh
echo  "source $3"> 03.support.sh
echo "source $3" > 04.extraction.sh
echo "source $3" >05.assembly.sh
echo "source $3" >06.output.sh

echo "Jelly.py setup $1 2>run.log" >> 01.setup.sh
echo "Jelly.py mapping $1 2>>run.log" >> 02.mapping.sh
echo "Jelly.py support $1 2>>run.log" >> 03.support.sh
echo "Jelly.py extraction $1 2>>run.log" >> 04.extraction.sh
echo "Jelly.py assembly $1 -x \"-n $2\" 2>>run.log" >>05.assembly.sh
echo "Jelly.py output $1 2>>run.log" >>06.output.sh

#echo "mv 01.setup.sh 01.setup.done.sh" >>01.setup.sh
#echo "mv 02.mapping.sh 02.mapping.done.sh" >>02.mapping.sh
#echo "mv 03.support.sh 03.support.done.sh" >>03.support.sh
#echo "mv 04.extraction.sh 04.extraction.done.sh" >>04.extraction.sh
#echo "mv 05.assembly.sh 05.assembly.done.sh" >>05.assembly.sh
#echo "mv 06.output.sh 06.output.done.sh" >>06.output.sh

