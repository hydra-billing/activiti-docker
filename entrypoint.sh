#!/bin/bash

bash /jdbc.sh
if [ $? -ne 0 ]; then
	echo "Container start failed, now exiting..."
	exit 1
else
	/usr/local/tomcat/bin/catalina.sh run
fi
