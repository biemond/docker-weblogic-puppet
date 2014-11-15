### WebLogic 12.1.3 Docker image

it will download a minimal CentOS 7 image, Puppet 3.7 and all it dependencies

You can also use use the official Oracle Linux 7.0 docker image, just do the following
- wget http://public-yum.oracle.com/docker-images/OracleLinux/OL7/oraclelinux-7.0.tar.xz
- docker load -i oraclelinux-7.0.tar.xz
- docker run --rm -i -t oraclelinux:7.0 /bin/bash
- Change the first line of the Dockerfile to FROM oraclelinux:7.0

Configures Puppet, Hiera and use librarian-puppet to download all the modules from puppet forge

### Result
- WebLogic 12.1.3 AdminServer on port 7001, password = weblogic1
- Cluster with one member on port 8001
- Distributed JMS
- Nodemanager port 5556

or configure your own weblogic environment by changing the common.yaml and build a new image

### Software
Download the following software from Oracle and Agree to the license
- jdk-7u55-linux-x64.tar.gz
- fmw_12.1.3.0.0_wls.jar

Add them to this docker folder

### Build image (~3.1GB)
docker build -t oracle/weblogic1213 .

probably you want to compress it, just go to the Compress section for more information

### Start container
default, it will start the Nodemanager & the AdminServer
- docker run -i -t -p 7001:7001 -p 8001:8001 -p 5556:5556 oracle/weblogic1213:latest

with bash

docker run -i -t -p 7001:7001 -p 8001:8001 -p 5556:5556 oracle/weblogic1213:latest /bin/bash
- start /startWls.sh

### Compress image (now ~1.8GB)
- ID=$(docker run -d oracle/weblogic1213:latest /bin/bash)
- docker export $ID > weblogic1213.tar
- cat weblogic1213.tar | docker import - weblogic1213
- docker run -i -t -p 7001:7001 -p 8001:8001 -p 5556:5556 weblogic1213:latest /bin/bash
- /startWls.sh


### Boot2docker, MAC OSX

VirtualBox forward rules
- VBoxManage controlvm boot2docker-vm natpf1 "weblogic-admin,tcp,,7001,,7001"
- VBoxManage controlvm boot2docker-vm natpf1 "weblogic-wls,tcp,,8001,,8001"
- VBoxManage controlvm boot2docker-vm natpf1 "weblogic-ndmgr,tcp,,5556,,5556"

Check the ipaddress
- boot2docker ip

Check Weblogic console
- curl http://x.x.x.x:7001/console