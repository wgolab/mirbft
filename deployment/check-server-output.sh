#!/bin/bash

servers=$(grep server cloud-instance.info | awk '{ print $1}')
S=$(grep -c server cloud-instance.info)

. vars.sh

Y=0
N=0
for p in $servers; do
    grep 'with [1-9][0-9][0-9]' experiment-output/$p.out > /dev/null
    if [ $? -eq 0 ] 
    then
	Y=$((Y+1))
    else
	N=$((N+1))
    fi
    C=`grep 'with [1-9][0-9][0-9]' experiment-output/$p.out | wc -l`
    echo Checking experiment-output/$p.out, found $C batches
done

echo Done checking batches with triple digit size
echo - number of servers with said batches: $Y
echo - number of servers without:           $N
