#!/bin/bash

set -e
set -x


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

set +x
source env/jenkinsrc
set -x

mkdir -p clusters

touch clusters/j${BUILD_NUMBER}.json

./mkcluster -c j${BUILD_NUMBER} -p simple

popd
