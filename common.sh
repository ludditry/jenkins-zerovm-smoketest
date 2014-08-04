#!/bin/bash

set -e
set -x

CLUSTER_ID=${CLUSTER_ID:-BUILD_NUMBER}

# ensure ansible all set up
if [ ! -d /var/lib/jenkins/ansible-zwift ]; then
    pushd /var/lib/jenkins
    git clone http://github.com/ludditry/ansible-zwift
    popd
fi

pushd /var/lib/jenkins/ansible-zwift

git reset --hard
git checkout master
git pull

if [ ! -d venv ]; then
    virtualenv venv
fi

source venv/bin/activate

pip install -r requirements.txt

if [ ! -e env ]; then
    echo "drop a jenkinsrc in /var/lib/jenkins/ansible-zwift/env"
    exit 1
fi

mkdir -p roles/base/files
cp ${WORKSPACE}/keys/* roles/base/files

set +x
source env/jenkinsrc
set -x

SWIFT_TYPE=${SWIFT_TYPE:-testing}
SWIFT_VERSION=${SWIFT_VERSION:-00049}
ZVM_VERSION=${ZVM_VERSION:-00056}

if [ "${SWIFT_VERSION}" == "AUTO" ]; then
    SWIFT_VERSION=$(cat /var/www/${SWIFT_TYPE}/snapshot-version)
fi

if [ "${ZVM_VERSION}" == "AUTO" ]; then
    ZVM_VERSION=$(cat /var/www/cbundles/${ZVM_TYPE}/snapshot-version)
fi
