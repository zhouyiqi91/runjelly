#! /bin/bash

dir_path=`pwd`
sed -i "2c dir_path=$dir_path" setup.config
chmod +x $dir_path/bin/*
chmod 777 $dir_path/bin/user.log
echo "checking networkx..."
bool=`pip list 2>/dev/null|grep -c "networkx (1.1)"`
if [ "$bool" != "1" ];then
    echo "networkx 1.1 not installed!"
    echo "pip installing networkx 1.1 into ./software ..."
    mkdir pythonlib
    pip install networkx==1.1 -t ./pythonlib
    pip install numpy -t ./pythonlib
    pip install pyparsing -t ./pythonlib

    echo "" >> ./setup.config
    echo "#networkx" >>  ./setup.config
    echo  "export PYTHONPATH=\$PYTHONPATH:\$dir_path/pythonlib" >> ./setup.config
fi

