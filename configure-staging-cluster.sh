#!/bin/bash

set -e
set -x

# activate and pushd to ansible checkout
source common.sh

SWIFT_TYPE=${SWIFT_TYPE:-testing}
SWIFT_VERSION=${SWIFT_VERSION:-00049}
ZVM_VERSION=${ZVM_VERSION:-00056}
WORKSPACE=${WORKSPACE:-.}

if [ ! -e clusters/j${CLUSTER_ID}.json ]; then
    echo "cluster j${CLUSTER_ID} does not exist"
    exit 1
fi

cp ${WORKSPACE}/job.template clusters/j${CLUSTER_ID}.json

sed -i clusters/j${CLUSTER_ID}.json -e "s#@SWIFT_TYPE@#${SWIFT_TYPE}#"
sed -i clusters/j${CLUSTER_ID}.json -e "s#@SWIFT_VERSION@#$SWIFT_VERSION#"
sed -i clusters/j${CLUSTER_ID}.json -e "s#@ZVM_VERSION@#${ZVM_VERSION}#"
sed -i clusters/j${CLUSTER_ID}.json -e "s#@PREFIX@#j${CLUSTER_ID}#"

./run -c j${CLUSTER_ID} -e @clusters/j${CLUSTER_ID}.json ./configure.yml

popd
