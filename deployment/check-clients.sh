#!/bin/bash -e

getIP() {
	grep -w $1 cloud-instance.info | awk '{ print $2}'
}

servers=$(grep server cloud-instance.info | awk '{ print $1}')
clients=$(grep client cloud-instance.info | awk '{ print $1}')

. vars.sh

for p in $clients; do
    pub=$(getIP $p)
    ssh $ssh_options $ssh_user@$pub "cat /opt/gopath/src/github.com/IBM/mirbft/client/client.out" &
done
wait
