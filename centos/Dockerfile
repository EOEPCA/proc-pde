FROM centos:7 

MAINTAINER Terradue S.r.l

USER root

# yum
ADD centos/install-yum.bash /tmp/install-yum.bash
ADD centos/yum.list /tmp/yum.list
RUN set -x && chmod 755 /tmp/install-yum.bash && /tmp/install-yum.bash

ENV NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    SHELL=bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    CONDA_DIR=/opt/anaconda \
    NB_PYTHON_PREFIX=/opt/anaconda/envs/notebook
    
ENV USER=${NB_USER} \
    NB_UID=${NB_UID} \
    HOME=/home/${NB_USER} \
    PATH=$NB_PYTHON_PREFIX/bin:$CONDA_DIR/bin:$PATH
    
ADD centos/fix-permissions /usr/local/bin/fix-permissions

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chmod g+w /etc/passwd /etc/group && \
    fix-permissions $HOME

#RUN groupadd docker -g 5003

RUN usermod -a -G docker jovyan

# conda installation via miniforge
ADD common/install-miniforge.bash /tmp/install-miniforge.bash

ADD common/environment.yml /tmp/environment.yml

RUN chmod 755 /tmp/install-miniforge.bash && /tmp/install-miniforge.bash

# extensions
ADD common/install-extensions.bash /tmp/install-extensions.bash

RUN chmod 755 /tmp/install-extensions.bash && /tmp/install-extensions.bash

# jupyter config
ADD common/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

# data
RUN mkdir -p /workspace/data && chown -R ${NB_USER}:${NB_GID} /workspace

RUN chown -R ${NB_USER}:${NB_GID} /workspace

# clean-up
RUN rm -f /tmp/install-*.bash && rm -f /tmp/environment.yml 

# for binder additional kernels
RUN mkdir -p /usr/local/share/jupyter && chown -R $NB_USER:$NB_GID /usr/local/share/jupyter

# fix permissions
RUN chown -R $NB_USER:$NB_GID ${HOME} 

RUN mkdir /opt/theia && chown -R $NB_USER:$NB_GID /opt/theia

ADD centos/start /usr/bin/start

USER ${NB_USER}

# setup conda activate/deactivate
RUN ${CONDA_DIR}/bin/conda init bash && source ${HOME}/.bashrc

# workdir for binder
WORKDIR ${HOME}

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash

RUN source ${HOME}/.bashrc && nvm install 12 && npm install -g yarn

RUN source ${HOME}/.bashrc

ADD common/package.json /opt/theia/package.json

RUN source /home/jovyan/.bashrc && cd /opt/theia && THEIA_ELECTRON_SKIP_REPLACE_FFMPEG=1 yarn 

RUN source /home/jovyan/.bashrc && cd /opt/theia &&  yarn theia build 

RUN source /home/jovyan/.bashrc && yarn cache clean

