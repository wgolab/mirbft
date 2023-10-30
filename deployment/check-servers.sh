#!/bin/bash -e

getIP() {
	grep -w $1 cloud-instance.info | awk '{ print $2}'
}

servers=$(grep server cloud-instance.info | awk '{ print $1}')
clients=$(grep client cloud-instance.info | awk '{ print $1}')

. vars.sh

for p in $servers; do
    pub=$(getIP $p)
    echo $p
    echo $pub
    ssh $ssh_options $ssh_user@$pub "tail /opt/gopath/src/github.com/IBM/mirbft/server/server.out" &
done
wait
