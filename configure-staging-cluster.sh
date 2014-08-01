#!/bin/bash

set -e
set -x

CLUSTER_ID=${CLUSTER_ID:-JOB_ID}
SWIFT_TYPE=${SWIFT_VENV_CLASS:-testing}
SWIFT_VERSION=${SWIFT_BUNDLE_VERSION:-00049}
ZVM_VERSION=${00056}
WORKSPACE=${WORKSPACE:-.}

[ -d /var/lib/jenkins/ansible-zwift ] || exit 1
pushd /var/lib/jenkins/ansible-zwift

[ -d venv ] || exit 1

source venv/bin/activate

[ -e env/jenkinsrc ] || exit 1

set +x
source env/jenkinsrc
set -x

if [ ! -e clusters/j${CLUSTER_ID}.json ]; then
    echo "cluster j${CLUSTER_ID} does not exist"
    exit 1
fi

cp ${WORKSPACE}/job.template clusters/j${CLUSTER_ID}.json

sed -i clusters/j${CLUSTER_ID}.json -e "#@SWIFT_TYPE@#${SWIFT_TYPE}#"
sed -i clusters/j${CLUSTER_ID}.json -e "#@SWIFT_VERSION@#$SWIFT_VERSION#"
sed -i clusters/j${CLUSTER_ID}.json -e "#@ZVM_VERSION@#${ZVM_VERSION}#"
sed -i clusters/j${CLUSTER_ID}.json -e "#@PREFIX@#j${CLUSTER_ID}#"

./run -c j${CLUSTER_ID} -e @clusters/j${CLUSTER_ID}.json ./configure.yml

popd
