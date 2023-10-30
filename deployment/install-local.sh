#!/bin/bash

export user=$(id -un)
export group=$(id -gn)

sudo yum update
#sudo yum install -y curl
sudo yum install -y git
sudo yum install -y python
sudo yum install -y python-numpy
#sudo yum install -y build-essential
#sudo yum groupinstall 'Development Tools'
sudo yum install -y protobuf-compiler
sudo yum reinstall -y protobuf-compiler
#sudo yum install -y protobuf-compiler-grpc

cd ~

# WG needed to correct bad deploys
GFILE="go1.19.13.linux-amd64.tar.gz"
if test -f "$GFILE"; then
    echo "$GFILE exists."
else
    wget "https://storage.googleapis.com/golang/$GFILE"
fi
rm -fr go
tar xpzf $GFILE

sudo rm -fr /opt/gopath
sudo mkdir -p /opt/gopath
sudo chown -R  $user:$group /opt/gopath

export PATH=$PATH:~/go/bin/:/opt/gopath/bin/
export GOPATH=/opt/gopath
export GOROOT=~/go
export GIT_SSL_NO_VERIFY=1
export GO111MODULE=off
export GOPROXY=https://proxy.golang.org

cat << EOF >> ~/.bashrc
export PATH=$PATH:~/go/bin/:/opt/gopath/bin/
export GOPATH=/opt/gopath
export GOROOT=~/go
export GIT_SSL_NO_VERIFY=1
export GO111MODULE=off
export GOPROXY=https://proxy.golang.org
EOF

go get -u google.golang.org/grpc
go get -u github.com/golang/protobuf/protoc-gen-go
go get -u github.com/op/go-logging
go get -u golang.org/x/net/context
go get -u  gopkg.in/yaml.v2
go get -u github.com/rs/zerolog/log
echo "Done install-local.sh"
