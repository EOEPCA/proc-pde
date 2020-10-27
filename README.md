# Processor Development Environment (PDE)

The Processor Development Environment provides a rich, interactive environment in which processing algorithms and services are developed, tested, debugged and ultimately packaged so that they can be deployed to the platform and published via the marketplace.

The PDE supports the packaging of the user’s application in accordance with the Application Packaging format that is suitable for deployment at the EMS/ADES. 

It provides a sandboxed environment in which the user can test the deployment and execution of their packaged application, with access to suitable test data to perform the validation.

## Using Centos

You can use the built image and do:

```bash
docker run --rm -it -p 8889:8889 -p 8890:8888  centos-pde:latest start jupyter lab --ip=0.0.0.0 --port=8888 --config=/etc/jupyter/jupyter_notebook_config.py --no-browser --notebook-dir /workspace --allow-root --NotebookApp.token=""
```

Or build and run with docker compose:

```bash
git clone https://github.com/EOEPCA/proc-pde.git

cd proc-pde/centos
docker-compose build centos-pde

docker-compose up
```

Open the browser at the URL 0.0.0.0:8890 or 127.0.0.1:8890 to access the JupyterLab interface

## Using Debian

Coming soon!