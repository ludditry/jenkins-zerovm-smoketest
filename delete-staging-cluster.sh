#!/bin/bash

set -e
set -x

CLUSTER_ID=${CLUSTER_ID:-JOB_ID}


[ -d /var/lib/jenkins/ansible-swift ] || exit 1
pushd /var/lib/jenkins/ansible-swift

[ -d venv] || exit 1

source venv/bin/activate

[ -e env/jenkinsrc ] || exit 1

set +x
source env/jenkinsrc
set -x

if [ -e clusters/j${CLUSTER_ID}.json ]; then
    echo "cluster j${CLUSTER_ID} does not exist"
    exit 1
fi

rm clusters/j${CLUSTER_ID}.json

./rmcluster -c j${CLUSTER_ID}

popd
