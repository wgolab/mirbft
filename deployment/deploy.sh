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

echo "Copying scripts"
for p in $servers $clients; do
         pub=$(getIP $p)
         if [ "$pull" = "false" ]; then
             scp $ssh_options clone.sh install-local.sh vars.sh run-client.sh run-server.sh stop.sh $ssh_user@$pub: &
	 fi
done
wait

rm -f deploy*.log
rm -f clone*.log
echo "Executing scripts, this may take a while ..."
for p in $servers $clients; do
         pub=$(getIP $p)
         if [ "$pull" = "false" ]; then
             ssh $ssh_user@$pub $ssh_options "source install-local.sh; source clone.sh" > deploy-$p.log 2>&1 &
         else
             ssh $ssh_user@$pub $ssh_options "source clone.sh" > clone-$p.log 2>&1 &
	 fi
done
wait

echo "Generating configuration ..."
./config-gen.sh
