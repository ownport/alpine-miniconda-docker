FROM ownport/alpine-glibc:3.7

# Configure Miniconda environment
# Miniconda installer archive, https://repo.continuum.io/miniconda/
# https://repo.continuum.io/miniconda/Miniconda2-4.3.31-Linux-x86.sh
# https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

ENV CONDA_DIR=/opt/conda \
    PATH="/opt/conda/bin:$PATH" \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV MINICONDA_VER 4.3.31
ENV MINICONDA Miniconda3-${MINICONDA_VER}-Linux-x86_64.sh 
ENV MINICONDA_URL https://repo.continuum.io/miniconda/${MINICONDA}
ENV MINICONDA_MD5_SUM 7fe70b214bee1143e3e3f0467b71453c

# COPY Miniconda3-4.3.31-Linux-x86_64.sh /tmp/miniconda.sh

RUN echo "[INFO] Create directories" && \
        mkdir -p \
            ${CONDA_DIR} \
            /data && \
    echo "[INFO] Install base components" && \
        apk add --no-cache \
            bash && \
    echo "[INFO] Install build deps" && \
        apk add --no-cache --virtual .build-deps \
                wget \
                bzip2 \
                unzip && \
    echo "[INFO] Install miniconda" && \
        wget -N --progress=dot:mega ${MINICONDA_URL} -O /tmp/miniconda.sh && \
        echo "${MINICONDA_MD5_SUM}  /tmp/miniconda.sh" | md5sum -c - && \
        /bin/bash /tmp/miniconda.sh -f -b -p ${CONDA_DIR} && \
        echo "export PATH=$CONDA_DIR/bin:\$PATH" > /etc/profile.d/conda.sh && \
        conda update --all --yes && \
        conda config --set auto_update_conda False && \    
    echo "[INFO] Remove build deps and clear temp files" && \
        apk del .build-deps && \
            rm -rf ${CONDA_DIR}/pkgs/* && \
            rm -rf tmp/*

        # ${CONDA_DIR}/bin/conda install --yes conda==${MINICONDA_VER} && \


WORKDIR /data
CMD ["/bin/bash"]
