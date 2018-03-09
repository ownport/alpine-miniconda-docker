#!/bin/sh

set -eu

# Configure Miniconda environment
# Miniconda installer archive, https://repo.continuum.io/miniconda/

export CONDA_DIR=/opt/conda 
export PATH="/opt/conda/bin:$PATH" 

export MINICONDA_VER=4.4.10
export MINICONDA=Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh 
export MINICONDA_URL=https://repo.continuum.io/miniconda/${MINICONDA}
export MINICONDA_MD5_SUM=bec6203dbb2f53011e974e9bf4d46e93

echo "[INFO] Create directories" && \
        mkdir -p \
            ${CONDA_DIR} \
            /data

echo "[INFO] Install base components" && \
    apk add --no-cache \
        bash

echo "[INFO] Install build deps" && \
    apk add --no-cache --virtual .build-deps \
            wget \
            bzip2 \
            unzip

echo "[INFO] Install miniconda" && \
    wget -N --progress=dot:mega ${MINICONDA_URL} -O /tmp/miniconda.sh && \
    echo "${MINICONDA_MD5_SUM}  /tmp/miniconda.sh" | md5sum -c - && \
    /bin/bash /tmp/miniconda.sh -f -b -p ${CONDA_DIR} && \
    echo "export PATH=$CONDA_DIR/bin:\$PATH" > /etc/profile.d/conda.sh && \
    conda update --all --yes && \
    conda config --set auto_update_conda False

echo "[INFO] Remove build deps and clear temp files" && \
    apk del .build-deps && \
        rm -rf ${CONDA_DIR}/pkgs/* && \
        rm -rf tmp/*
