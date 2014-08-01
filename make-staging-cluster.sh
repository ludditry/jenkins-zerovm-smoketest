#!/bin/bash

set -e
set -x

source common.sh

mkdir -p clusters

touch clusters/j${CLUSTER_ID}.json

./mkcluster -c j${CLUSTER_ID} -p simple

popd
