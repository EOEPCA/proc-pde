#!/bin/bash

set -ex

# make sure we don't do anything funky with user's $HOME
# since this is run as root
unset HOME
NB_PYTHON_PREFIX=/srv/conda
# required extensions
${NB_PYTHON_PREFIX}/bin/jupyter nbextension enable --py --sys-prefix widgetsnbextension

${NB_PYTHON_PREFIX}/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager@2.0

# file tree
${NB_PYTHON_PREFIX}/bin/jupyter labextension install jupyterlab_filetree


# ipyleaflet
${NB_PYTHON_PREFIX}/bin/jupyter labextension install jupyter-leaflet
${NB_PYTHON_PREFIX}/bin/jupyter nbextension enable --py --sys-prefix ipyleaflet

# voila
${NB_PYTHON_PREFIX}/bin/jupyter nbextension install voila --sys-prefix --py
${NB_PYTHON_PREFIX}/bin/jupyter nbextension enable voila --sys-prefix --py

# voila preview on jupyter lab (voila is used via notebook, not via lab)
${NB_PYTHON_PREFIX}/bin/jupyter labextension install @jupyter-voila/jupyterlab-preview

# geojson
${NB_PYTHON_PREFIX}/bin/jupyter labextension install @jupyterlab/geojson-extension

# sidecar
${NB_PYTHON_PREFIX}/bin/pip install sidecar
${NB_PYTHON_PREFIX}/bin/jupyter labextension install @jupyter-widgets/jupyterlab-sidecar

# templates
#${NB_PYTHON_PREFIX}/bin/pip install jupyterlab_templates
#${NB_PYTHON_PREFIX}/bin/jupyter labextension install jupyterlab_templates
#${NB_PYTHON_PREFIX}/bin/jupyter serverextension enable jupyterlab_templates --py 

# bash kernel
${NB_PYTHON_PREFIX}/bin/pip install bash_kernel
${NB_PYTHON_PREFIX}/bin/python -m bash_kernel.install

## EOEPCA-382
# quick open
## ${NB_PYTHON_PREFIX}/bin/pip install jupyterlab-quickopen
## ${NB_PYTHON_PREFIX}/bin/jupyter labextension install @parente/jupyterlab-quickopen
## ${NB_PYTHON_PREFIX}/bin/jupyter serverextension enable jupyterlab_quickopen --sys-prefix --py

# table of contents
${NB_PYTHON_PREFIX}/bin/jupyter labextension install @jupyterlab/toc

# collapsible headings
${NB_PYTHON_PREFIX}/bin/jupyter labextension install @aquirdturtle/collapsible_headings

### below this line the extensions fails to install or are incomplete
# jupyter lsp
# https://github.com/krassowski/jupyterlab-lsp
#${NB_PYTHON_PREFIX}/bin/pip install jupyter-lsp
#${NB_PYTHON_PREFIX}/bin/jupyter labextension install @krassowski/jupyterlab-lsp 
#${NB_PYTHON_PREFIX}/bin/pip install python-language-server[all]

# git
# https://github.com/jupyterlab/jupyterlab-git
#${NB_PYTHON_PREFIX}/bin/pip install --upgrade jupyterlab-git
#${NB_PYTHON_PREFIX}/bin/jupyter labextension install @jupyterlab/git
#${NB_PYTHON_PREFIX}/bin/jupyter serverextension enable --py jupyterlab_git


# server proxy
${NB_PYTHON_PREFIX}/bin/pip install jupyter-server-proxy
#${NB_PYTHON_PREFIX}/bin/jupyter serverextension enable --sys-prefix jupyter_server_proxy
${NB_PYTHON_PREFIX}/bin/jupyter labextension install @jupyterlab/server-proxy
# theia
# see https://discourse.jupyter.org/t/unable-to-get-jupyter-server-proxy-working-on-theia/3104/4
#curl -o- -L https://yarnpkg.com/install.sh | bash
#mv /tmp/package.json . 
#yarn
#yarn theia build
#export PATH="$(pwd)/node_modules/.bin:${PATH}"

# conda
#${CONDA_DIR}/bin/conda install -n notebook -c conda-forge jupyter_conda
#${NB_PYTHON_PREFIX}/bin/jupyter labextension install jupyterlab_toastify jupyterlab_conda

# qgrid
#${NB_PYTHON_PREFIX}/bin/pip install qgrid
#${NB_PYTHON_PREFIX}/bin/jupyter labextension install qgrid
#${NB_PYTHON_PREFIX}/bin/jupyter nbextension enable --py --sys-prefix qgrid


# Remove the pip cache created as part of installing sidecar
rm -rf /root/.cache
rm -fr /tmp/npm*
rm -fr /tmp/yarn*
rm -fr /tmp/v8-compile-cache-*