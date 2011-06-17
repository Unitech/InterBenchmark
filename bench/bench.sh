#!/bin/bash

IP=192.168.1.46
PLOT_FILE="plot.p"
#

declare -A app=( 
    ["ruby"]=81
    ["django"]='82/polls'
#    ["php"]=83
#    ["webpy"]=84
#    ["web2py"]='85/welcome/default/index'
#    ["symfony"]=86
    ["node"]=89
    ["express"]=88)

if [ $# -ne 3 ]
then
    echo 'Usage : ./bench REQ_NB REQ_CONCURENCY Y_SIZE'
    exit 1
fi

echo "
set terminal png
set output \"out.png\"

set grid

set title  \"ab -n ${1} -c ${2}\"
set yrange[0:${3}]
set label \"blog.hemca.com\" at graph 0.01, 0.95

set xlabel \"request\"
set ylabel \"response time (ms)\"

set size 1.0, 0.7
plot \\" > $PLOT_FILE

for b in "${!app[@]}";do
    echo -e "\033[31;1m+----- Benchmarking $b on port ${app["$b"]}\033[0m";
    TMP_FILE="out-$b.dat"
    echo "ab -n $1 -c $2 -g ${TMP_FILE} http://$IP:${app["$b"]}/"
    ab -n $1 -c $2 -g ${TMP_FILE} http://$IP:${app["$b"]}/
    echo "    \"${TMP_FILE}\" using 9 smooth sbezier with lines title \"${b} ${app["${b}"]}\", \\" >> $PLOT_FILE
done

sed -i '$s/.$//' $PLOT_FILE
sed -i '$s/.$//' $PLOT_FILE
sed -i '$s/.$//' $PLOT_FILE

gnuplot $PLOT_FILE
display out.png
