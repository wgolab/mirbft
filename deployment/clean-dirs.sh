#!/bin/bash -e

getIP() {
	grep -w $1 cloud-instance.info | awk '{ print $2}'
}

servers=$(grep server cloud-instance.info | awk '{ print $1}')
clients=$(grep client cloud-instance.info | awk '{ print $1}')

. vars.sh

if [ "$1" = "--pull-only" ] || [ "$1" = "-p" ]; then
  pull=true
  shift
else
  pull=false
fi

for p in $servers $clients; do
    pub=$(getIP $p)
    ssh $ssh_user@$pub $ssh_options "rm -fr ~/go; sudo rm -fr /opt/gopath" &
done
wait
