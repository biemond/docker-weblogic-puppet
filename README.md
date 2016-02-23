### WebLogic 12.1.3 Docker image

it will download a minimal Oracle Linux 7 image, Puppet and all its dependencies

Configures Puppet, Hiera and use librarian-puppet to download all the required modules from puppet forge

### Result
- WebLogic 12.1.3 AdminServer on port 7001, password = weblogic1
- Cluster with one member on port 8001
- Distributed JMS
- Nodemanager port 5556

or configure your own WebLogic environment by changing the common.yaml and build your own WLS image

### Software
Download the following software from Oracle and Agree to the license
- jdk-7u55-linux-x64.tar.gz
- fmw_12.1.3.0.0_wls.jar

Add them to this src/main/docker/wls directory

### Build image (~2.6GB)
- cd src/main/docker/wls
- docker build -t oracle/weblogic1213 .

or with maven
- mvn package, build image
- mvn verify, local bring up, test and destroy
- mvn install, bring up


probably you want to compress it, just go to the Compress section for more information

### Start container
default, it will start the Nodemanager & the AdminServer
- docker run -i -t -p 7001:7001 -p 8101:8101 -p 5556:5556 oracle/weblogic1213:latest

with bash

docker run -i -t -p 7001:7001 -p 8101:8101 -p 5556:5556 oracle/weblogic1213:latest /bin/bash
- start /startWls.sh

### Compress image (now ~1.8GB)
- ID=$(docker run -d oracle/weblogic1213:latest /bin/bash)
- docker export $ID > weblogic1213.tar
- cat weblogic1213.tar | docker import - weblogic1213
- docker run -i -t -p 7001:7001 -p 8101:8101 -p 5556:5556 weblogic1213:latest /bin/bash
- /startWls.sh

### fusion

- docker-machine create --driver vmwarefusion --vmwarefusion-disk-size 40960 vm

- docker-machine ip {{ your machine name }}
- /Library/Preferences/VMware\ Fusion/vmnet8/nat.conf

Find the section:
```
[incomingtcp]
# Use these with care - anyone can enter into your VM through these...
# The format and example are as follows:
#<external port number> = <VM's IP address>:<VM's port number>
80 = {{ your machine ip }}:80
```
Now run the following:

- sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
- sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start