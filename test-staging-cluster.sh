#!/bin/bash

set -e
set -x

source common.sh

WORKSPACE=${WORKSPACE:-.}

pip install python-swiftclient

./run -c j${CLUSTER_ID} -e @clusters/j${CLUSTER_ID}.json -e rc_path=../env/j${CLUSTER_ID}-swift.env contrib/swiftrc.yml
./run -c j${CLUSTER_ID} -e @clusters/j${CLUSTER_ID}.json -e zsys_interface=eth2 contrib/fixup-zbroker.yml

set +x
source env/j${CLUSTER_ID}-swift.env
set -x

popd

# upload test data
pushd ${WORKSPACE}/scaffold
for d in *; do
    pushd ${d}
    swift --insecure upload $(basename ${d}) *
    popd
done
popd

[ $(./zexec scripts simple_map_reduce.json) == 'Ok' ]

# if we haven't died by now, we can mark these as tested.
echo ${ZVM_VERSION} > /var/www/cbundles/${ZVM_TYPE}/tested-version
echo ${SWIFT_VERSION} > /var/www/${SWIFT_TYPE}/tested-version
