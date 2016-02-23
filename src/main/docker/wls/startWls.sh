#!/bin/sh
# *************************************************************************

echo "Cleanup old AdminServer nodemanager files"

rm -rf /opt/oracle/wlsdomains/domains/Wls1213/servers/AdminServer/data/nodemanager/AdminServer.lck
rm -rf /opt/oracle/wlsdomains/domains/Wls1213/servers/AdminServer/data/nodemanager/AdminServer.pid
rm -rf /opt/oracle/wlsdomains/domains/Wls1213/servers/AdminServer/data/nodemanager/AdminServer.state

echo "Start Nodemanager"
/opt/scripts/wls/startNodeManager.sh

echo "Start the AdminServer"
/opt/scripts/wls/startWeblogicAdmin.sh

echo "Done"