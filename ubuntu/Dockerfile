FROM nestybox/ubuntu-bionic-docker:latest 
#ubuntu-bionic-systemd-docker:latest

USER root

ENV LC_ALL=en_US.UTF-8                                                  \
    LANG=en_US.UTF-8                                                    \
    LANGUAGE=en_US.UTF-8                                                \
    SHELL=/bin/bash                                                     \
    PATH=/srv/conda/bin:$PATH                                           \
    NB_USER=jovyan                                                      \
    NB_UID=1002                                                         \
    NB_GID=1002                                                         \
    USER=jovyan                                                         \ 
    HOME=/home/jovyan                                                   \
    CONDA_DIR=/srv/conda/                                               \
    APP_BASE=/srv 
    
RUN groupadd --gid ${NB_GID} ${NB_USER} &&                              \
    useradd --comment "Default user"                                    \
            --create-home                                               \
            --gid ${NB_GID}                                             \
            --no-log-init                                               \
            --shell /bin/bash                                           \
            --uid ${NB_UID} ${NB_USER}

RUN apt-get -qq update &&                                               \
    apt-get -qq install --yes                                           \
    apt-utils                                                           \
    wget                                                                \
    make                                                                \
    g++                                                                 \
    sudo                                                                \
    vim                                                                 \
    tree                                                                \
    file                                                                \
    unzip

RUN wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key |  apt-key add - && \
    echo "deb https://deb.nodesource.com/node_10.x bionic main" >> /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/node_10.x bionic main" >> /etc/apt/sources.list.d/nodesource.list

RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add - && \
    sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'

RUN apt-get -qq update &&                                               \
    apt-get -qq install --yes --no-install-recommends                   \
    less                                                                \
    nodejs                                                              \
    unzip                                                               \
    git-flow                                                            \
    jenkins                                                             \
    openjdk-8-jdk                                                       \
    locales > /dev/null &&                                              \
    apt-get -qq purge &&                                                \
    apt-get -qq clean &&                                                \
    rm -rf /var/lib/apt/lists/*

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment &&                    \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&                      \ 
    echo "LANG=en_US.UTF-8" > /etc/locale.conf &&                       \
    locale-gen en_US.UTF-8

EXPOSE 8888

ENV NB_PYTHON_PREFIX=${CONDA_DIR}/envs/notebook                         \
    KERNEL_PYTHON_PREFIX=${NB_PYTHON_PREFIX}                            \
    PATH=${NB_PYTHON_PREFIX}/bin:${CONDA_DIR}/bin:${NPM_DIR}/bin:${PATH}\
    PATH=${HOME}/.local/bin:${PATH}                                     \
    CONDA_DEFAULT_ENV=${KERNEL_PYTHON_PREFIX}                           \
    NVM_DIR=$HOME/.nvm

COPY ubuntu/activate-conda.sh /etc/profile.d/activate-conda.sh

COPY common/environment.yml /tmp/environment.yml

COPY common/install-miniforge.bash /tmp/install-miniforge.bash

# miniforge
RUN bash /tmp/install-miniforge.bash &&                                 \
    rm /tmp/install-miniforge.bash /tmp/environment.yml

# extensions
ADD common/install-extensions.bash /tmp/install-extensions.bash

RUN chmod 755 /tmp/install-extensions.bash &&                           \
    /tmp/install-extensions.bash

# workspace
RUN mkdir -p /workspace &&                                              \
    chown -R ${NB_USER}:${NB_GID} /workspace

RUN mkdir -p /usr/local/share/jupyter &&                                \
    chown -R ${NB_USER}:${NB_GID} /usr/local/share/jupyter

ADD ubuntu/pde-sudo /etc/sudoers.d/pde-sudo
RUN chmod 440 /etc/sudoers.d/pde-sudo

# setup conda activate/deactivate
#RUN ${CONDA_DIR}/bin/conda init bash && . ${HOME}/.bashrc

RUN mkdir -p ${APP_BASE}/theia &&                                       \
    chown -R ${NB_USER}:${NB_GID} ${APP_BASE}/theia

ADD ubuntu/jenkins /etc/default/jenkins

RUN echo "export PATH=/srv/conda/envs/notebook/bin/:$PATH" >> /root/.bashrc
ENV PATH=/srv/conda/envs/notebook/bin/:$PATH

RUN mkdir /workspace/.jenkins &&                                        \
    chown -R jenkins:jenkins /workspace/.jenkins

# minio

# S3 config
ADD common/minio-config.json /home/jovyan/.mc/config.json 
ADD common/s3cfg /home/jovyan/.s3cfg

# additional utilities
ADD ubuntu/git-flow /usr/bin/git-flow
ADD common/release-flow /usr/bin/release-flow



# jupyter config
ADD common/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN wget --quiet https://dl.minio.io/server/minio/release/linux-amd64/minio && \
    chmod +x minio &&                                                       \
    mv minio /usr/bin/ &&                                                   \
    wget --quiet https://dl.min.io/client/mc/release/linux-amd64/mc &&      \
    chmod +x mc &&                                                          \
    mv mc /usr/bin/ &&                                                      \
    mkdir /data &&                                                          \
    chown -R 1002:1002 /data &&                                             \
    chown -R 1002:1002 /home/jovyan/.mc /home/jovyan/.s3cfg &&              \
    chmod 755 /usr/bin/git-flow &&                                          \
    chown -R 1002:1002 $HOME &&                                             \
    chmod 755 /usr/bin/release-flow  

USER ${NB_USER}

ADD ubuntu/jenkins-plugin-manager-2.1.2.jar /tmp/jenkins-plugin-manager-2.1.2.jar
ADD ubuntu/jenkins.plugins /tmp/jenkins.plugins.txt

#RUN conda init bash

WORKDIR /workspace

# theia
ADD common/package.json ${APP_BASE}/theia/package.json

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash

RUN . "$NVM_DIR/nvm.sh" &&                                              \
    npm config delete prefix &&                                         \
    nvm install 12.20.0 
    
       
RUN . "$NVM_DIR/nvm.sh" &&                                              \
    nvm use --delete-prefix v12.20.0 &&                                 \
    npm install -g yarn &&                                              \
    cd ${APP_BASE}/theia &&                                             \
    THEIA_ELECTRON_SKIP_REPLACE_FFMPEG=1 yarn &&                        \
    cd ${APP_BASE}/theia &&                                             \
    NODE_OPTIONS="--max_old_space_size=4096" &&                         \
    yarn theia build &&                                                 \
    yarn cache clean &&                                                 \
    echo "cd /workspace" >> /home/jovyan/.bashrc

# add start script
ADD ubuntu/start /usr/bin/start

# web site

RUN . "$NVM_DIR/nvm.sh" &&                                              \
    npm install -g node-static &&                                       \
    pip install mkdocs-material

USER root

RUN mkdir -p /var/www &&                                                \
    chown -R ${NB_USER}:${NB_GID} /var/www

COPY --chown=1002:1002 common/docs /var/www/

# patch conda persistence
RUN rm -fr /srv/conda/envs

USER ${NB_USER}

RUN cd /var/www/ &&                                                  \
    mkdocs build &&                                                  \
    rm -fr src && rm mkdocs.yml                                               
    


