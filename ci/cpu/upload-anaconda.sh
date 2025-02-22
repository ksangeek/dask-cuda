#!/bin/bash
#
# Adopted from https://github.com/tmcdonell/travis-scripts/blob/dfaac280ac2082cd6bcaba3217428347899f2975/update-accelerate-buildbot.sh

set -e

export UPLOADFILE=`conda build conda/recipes/dask-cuda --python=$PYTHON --output`
CUDA_REL=${CUDA_VERSION%.*}

SOURCE_BRANCH=master

LABEL_OPTION="--label main --label cuda9.2 --label cuda10.0"
echo "LABEL_OPTION=${LABEL_OPTION}"

# Restrict uploads to master branch
if [ ${GIT_BRANCH} != ${SOURCE_BRANCH} ]; then
  echo "Skipping upload"
  return 0
fi

if [ -z "$MY_UPLOAD_KEY" ]; then
    echo "No upload key"
    return 0
fi

echo "Upload"
echo ${UPLOADFILE}
anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} ${LABEL_OPTION} --force ${UPLOADFILE}
