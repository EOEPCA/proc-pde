#!/bin/bash

set -ex

cd /tmp/templates/

mkdir -p /workspace/templates

mv installers /workspace/templates/
mv templates  /workspace/templates/

cd -

rm -fr /tmp/templates/
