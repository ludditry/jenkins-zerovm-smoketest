#!/bin/bash

set -e
set -x

source common.sh

if [ ! -e clusters/j${CLUSTER_ID}.json ]; then
    echo "cluster j${CLUSTER_ID} does not exist"
    exit 1
fi

./rmcluster -c j${CLUSTER_ID}

rm -f clusters/j${CLUSTER_ID}.json
rm -f clusters/j${CLUSTER_ID}-swift.env

popd
