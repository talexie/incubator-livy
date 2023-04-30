#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libspark.sh
. /opt/bitnami/scripts/libos.sh

# Load Spark environment settings
. /opt/bitnami/scripts/spark-env.sh

if [ "$SPARK_MODE" == "master" ]; then
    # Master constants
    EXEC=$(command -v start-master.sh)
    ARGS=()
    info "** Starting Spark Connect server in master mode **"
elif [ "$SPARK_MODE" == "sparkconnect" ]; then
    # Master constants
    EXEC=$(command -v start-connect-server.sh)
    ARGS=("--packages org.apache.spark:spark-connect_2.12:3.4.0")
    info "** Starting Spark connect server in master mode **"
else
    # Worker constants
    EXEC=$(command -v start-worker.sh)
    ARGS=("$SPARK_MASTER_URL")
    info "** Starting Spark in worker mode **"
fi
if am_i_root; then
    exec_as_user "$SPARK_DAEMON_USER" "$EXEC" "${ARGS[@]-}"
else
    exec "$EXEC" "${ARGS[@]-}"
fi