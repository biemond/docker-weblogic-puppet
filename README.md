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

