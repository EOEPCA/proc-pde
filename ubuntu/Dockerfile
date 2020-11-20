FROM nestybox/ubuntu-bionic-docker:latest 
#ubuntu-bionic-systemd-docker:latest

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    SHELL=/bin/bash \
    PATH=/srv/conda/bin:$PATH

ENV NB_USER=jovyan \
    NB_UID=2001 \
    NB_GID=2000 
    
ENV USER=${NB_USER} \ 
    HOME=/home/${NB_USER}
    
RUN groupadd --gid ${NB_GID} ${NB_USER} && useradd --comment "Default user" --create-home --gid ${NB_GID} --no-log-init --shell /bin/bash --uid ${NB_UID} ${NB_USER}

RUN usermod -aG sudo jovyan

RUN apt-get -qq update && apt-get -qq install --yes apt-utils 

RUN apt-get -qq install --yes wget make g++ sudo vim

RUN wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key |  apt-key add - && DISTRO="bionic" && echo "deb https://deb.nodesource.com/node_10.x $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list && echo "deb-src https://deb.nodesource.com/node_10.x $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list

RUN apt-get -qq update && apt-get -qq install --yes --no-install-recommends less nodejs unzip git-flow locales > /dev/null && apt-get -qq purge && apt-get -qq clean && rm -rf /var/lib/apt/lists/*

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&  echo "LANG=en_US.UTF-8" > /etc/locale.conf &&  locale-gen en_US.UTF-8

EXPOSE 8888

ENV APP_BASE=/srv 

ENV CONDA_DIR=${APP_BASE}/conda 
    
ENV NB_PYTHON_PREFIX=${CONDA_DIR}/envs/notebook 

ENV KERNEL_PYTHON_PREFIX=${NB_PYTHON_PREFIX} \
    PATH=${NB_PYTHON_PREFIX}/bin:${CONDA_DIR}/bin:${NPM_DIR}/bin:${PATH}

COPY ubuntu/activate-conda.sh /etc/profile.d/activate-conda.sh

COPY common/environment.yml /tmp/environment.yml

COPY common/install-miniforge.bash /tmp/install-miniforge.bash

# miniforge
RUN bash /tmp/install-miniforge.bash && rm /tmp/install-miniforge.bash /tmp/environment.yml

# extensions
ADD common/install-extensions.bash /tmp/install-extensions.bash

RUN chmod 755 /tmp/install-extensions.bash && /tmp/install-extensions.bash

# data
RUN mkdir -p /workspace/data && chown -R ${NB_USER}:${NB_GID} /workspace

RUN chown -R ${NB_USER}:${NB_GID} /workspace

RUN mkdir -p /usr/local/share/jupyter && chown -R ${NB_USER}:${NB_GID} /usr/local/share/jupyter

ENV PATH ${HOME}/.local/bin:${PATH}

ENV CONDA_DEFAULT_ENV ${KERNEL_PYTHON_PREFIX}



ADD ubuntu/pde-sudo /etc/sudoers.d/pde-sudo

# setup conda activate/deactivate
#RUN ${CONDA_DIR}/bin/conda init bash && . ${HOME}/.bashrc

RUN mkdir -p ${APP_BASE}/theia && chown -R ${NB_USER}:${NB_GID} ${APP_BASE}/theia

USER ${NB_USER}

# workdir for binder
WORKDIR ${HOME}


RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash

ENV NVM_DIR=$HOME/.nvm
#ENV NPM_DIR=''

RUN . "$NVM_DIR/nvm.sh" && npm config delete prefix && nvm install 12 &&  npm install -g yarn

ADD common/package.json ${APP_BASE}/theia/package.json

USER ${NB_USER}

RUN . "$NVM_DIR/nvm.sh" && cd ${APP_BASE}/theia && THEIA_ELECTRON_SKIP_REPLACE_FFMPEG=1 yarn 

RUN . "$NVM_DIR/nvm.sh" && cd ${APP_BASE}/theia && NODE_OPTIONS="--max_old_space_size=4096" yarn theia build 

RUN . "$NVM_DIR/nvm.sh" && yarn cache clean

RUN echo "cd /workspace" >> /home/jovyan/.bashrc

# Jenkins

USER root

RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
RUN  sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
RUN apt-get update
RUN apt-get install -y jenkins

ENV CONDA_DIR=/srv/conda/envs/notebook

RUN apt-get install -y openjdk-8-jdk

ADD ubuntu/jenkins /etc/default/jenkins

RUN echo "export PATH=/srv/conda/envs/notebook/bin/:$PATH" >> /root/.bashrc
ENV PATH=/srv/conda/envs/notebook/bin/:$PATH

RUN conda init bash

RUN rm -f /etc/profile.d/activate-conda.sh

#ADD ubuntu/start1 /usr/bin/start

#RUN echo 2.249.3 >> /var/lib/jenkins/jenkins.install.UpgradeWizard.state
#RUN echo 2.249.3 >> /var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion

#RUN mkdir -p /var/lib/jenkins/init.groovy.d

#ADD ubuntu/basic-security.groovy /workspace/.jenkins/init.groovy.d/basic-security.groovy
RUN mkdir /workspace/.jenkins

RUN chown -R jenkins:jenkins /workspace/.jenkins

ADD ubuntu/start /usr/bin/start

# jupyter config
ADD common/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN apt-get -qq purge && apt-get -qq clean && rm -rf /var/lib/apt/lists/*

USER ${NB_USER}

ADD ubuntu/jenkins-plugin-manager-2.1.2.jar /tmp/jenkins-plugin-manager-2.1.2.jar

ADD ubuntu/jenkins.plugins /tmp/jenkins.plugins.txt

RUN conda init bash

WORKDIR /workspace



