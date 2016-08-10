#!/bin/bash

bash /jdbc.sh
if [ $? -ne 0 ]; then
	echo "Container start failed, now exiting..."
	exit 1
else
	catalina.sh run
fi
