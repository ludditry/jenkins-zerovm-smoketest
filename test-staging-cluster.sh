#!/bin/bash

set -e
set -x

source common.sh

SWIFT_TYPE=${SWIFT_TYPE:-testing}
SWIFT_VERSION=${SWIFT_VERSION:-00049}
ZVM_TYPE=${ZVM_TYPE:-zvm2-zpipes}
ZVM_VERSION=${ZVM_VERSION:-00056}
WORKSPACE=${WORKSPACE:-.}

pip install python-swiftclient

./run -c j${CLUSTER_ID} -e @clusters/j${CLUSTER_ID}.json -e rc_path=../env/j${CLUSTER_ID}-swift.env contrib/swiftrc.yml
set +x
source env/j${CLUSTER_ID}-swift.env
set -x

# upload test data
pushd ${WORKSPACE}/scaffold
for d in *; do
    pushd ${d}
    swift --insecure upload $(basename ${d}) *
    popd
done

popd

# if we haven't died by now, we can mark these as tested.
echo ${ZVM_VERSION} > /var/www/cbundles/${ZVM_TYPE}/tested-version
echo ${SWIFT_VERSION} > /var/www/${SWIFT_TYPE}/tested-version
