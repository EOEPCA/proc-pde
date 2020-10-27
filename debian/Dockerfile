FROM buildpack-deps:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && apt-get -qq install --yes --no-install-recommends locales > /dev/null && apt-get -qq purge && apt-get -qq clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen &&     locale-gen

ENV LC_ALL en_US.UTF-8

ENV LANG en_US.UTF-8

ENV LANGUAGE en_US.UTF-8

ENV SHELL /bin/bash

ENV NB_USER jovyan

ENV NB_UID 1000

ENV NB_GID 100

ENV USER ${NB_USER}

ENV HOME /home/${NB_USER}

RUN groupadd --gid ${NB_UID} ${NB_USER} && useradd --comment "Default user" --create-home --gid ${NB_UID} --no-log-init --shell /bin/bash --uid ${NB_UID} ${NB_USER}

RUN wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key |  apt-key add - && DISTRO="bionic" && echo "deb https://deb.nodesource.com/node_10.x $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list && echo "deb-src https://deb.nodesource.com/node_10.x $DISTRO main" >> /etc/apt/sources.list.d/nodesource.list

RUN apt-get -qq update && apt-get -qq install --yes --no-install-recommends less nodejs unzip > /dev/null && apt-get -qq purge && apt-get -qq clean && rm -rf /var/lib/apt/lists/*

# nextcloud
#COPY nextcloud-client.list /etc/apt/sources.list.d/nextcloud-client.list
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1FCD77DD0DBEF5699AD2610160EE47FBAD3DD469
#RUN apt-get -qq update && apt -qq install --yes --no-install-recommends nextcloud-client  > /dev/null && apt-get -qq purge && apt-get -qq clean && rm -rf /var/lib/apt/lists/*

EXPOSE 8888

ENV APP_BASE /srv

ENV NPM_DIR ${APP_BASE}/npm

ENV NPM_CONFIG_GLOBALCONFIG ${NPM_DIR}/npmrc

ENV CONDA_DIR ${APP_BASE}/conda

ENV NB_PYTHON_PREFIX ${CONDA_DIR}/envs/notebook

ENV KERNEL_PYTHON_PREFIX ${NB_PYTHON_PREFIX}

ENV PATH ${NB_PYTHON_PREFIX}/bin:${CONDA_DIR}/bin:${NPM_DIR}/bin:${PATH}

COPY debian/activate-conda.sh /etc/profile.d/activate-conda.sh

COPY debian/environment.yml /tmp/environment.yml

COPY debian/install-miniforge.bash /tmp/install-miniforge.bash

RUN mkdir -p ${NPM_DIR} && chown -R ${NB_USER}:${NB_USER} ${NPM_DIR}

USER ${NB_USER}

RUN npm config --global set prefix ${NPM_DIR}

USER root

RUN bash /tmp/install-miniforge.bash && rm /tmp/install-miniforge.bash /tmp/environment.yml

RUN mkdir -p /usr/local/share/jupyter && chown -R ${NB_USER}:${NB_GID} /usr/local/share/jupyter

ENV PATH ${HOME}/.local/bin:${PATH}

ENV CONDA_DEFAULT_ENV ${KERNEL_PYTHON_PREFIX}

