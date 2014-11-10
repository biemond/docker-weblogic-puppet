# WebLogic 12.1.3 Docker with puppet 3.7 on CentOS 7

it will download minimal CentOS 7 (latest), Puppet 3.7 and all it dependencies

Configures Puppet, Hiera and use librarian-puppet to download all the modules from puppet forge

## Result
- WebLogic 12.1.3 AdminServer on port 7001, password = weblogic1
- Cluster with one member on port 8001
- Distributed JMS
- Nodemanager port 5556

or configure your own weblogic environment by changing the common.yaml and build a new image

## Software
Download the following software from Oracle and Agree to the license
- jdk-7u55-linux-x64.tar.gz
- fmw_12.1.3.0.0_wls.jar

Add them to this docker folder

## Build image
docker build -t oracle/weblogic1213_centos7 .

## Remove image
docker rmi oracle/weblogic1213_centos7

## Start container

default, will start the nodemanager & adminserver
- docker run -i -t -p 7001:7001 -p 8001:8001 -p 5556:5556 oracle/weblogic1213_centos7:latest /startWls.sh

with bash

docker run -i -t -p 7001:7001 -p 8001:8001 -p 5556:5556 oracle/weblogic1213_centos7:latest /bin/bash
- start /startWls.sh

