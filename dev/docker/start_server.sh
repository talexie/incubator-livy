#!/usr/bin/env bash

echo "Starting the Server"
/opt/livy/server/bin/livy-server start
echo "Logging started."
tail -f /opt/livy/server/logs/livy--server.out


