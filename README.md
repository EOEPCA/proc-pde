# Processor Development Environment (PDE)

The Processor Development Environment provides a rich, interactive environment in which processing algorithms and services are developed, tested, debugged and ultimately packaged so that they can be deployed to the platform and published via the marketplace.

The PDE supports the packaging of the user’s application in accordance with the Application Packaging format that is suitable for deployment at the EMS/ADES. 

It provides a sandboxed environment in which the user can test the deployment and execution of their packaged application, with access to suitable test data to perform the validation.

The PDE provides a JupyterLab instance and the Cloud Theia IDE.

## Hosting the PDE

The PDE provides the developer with tools and a process to implement, test and create an Application Package. 

The developer uses CWL to describe his/her Application Package and uses `cwltool` to test it.

During the Application Package test phase, `cwltool` starts Docker containers and mounts volumes.

This leads to the docker-in-docker situation and to provide a clear isolation between the host and the PDE, we rely on sysbox which in turn relies on Linux features only available on Ubuntu. 

As such, hosting the PDE may be done at different levels:

**Full development process support** 

As explained above, this requires hosting the PDE with an Ubuntu host.

1) Install wget and docker

```console
apt-get update && apt install -y wget docker.io
```

2) Download the latest Sysbox community-edition package from the
[release](https://github.com/nestybox/sysbox/releases) page:

```console
$ wget https://github.com/nestybox/sysbox/releases/download/v0.2.1/sysbox_0.2.1-0.ubuntu-focal_amd64.deb
```

3) Verify that the checksum of the downloaded file fully matches the expected/published one.
   For example:

```console
$ sha256sum sysbox_0.2.1-0.ubuntu-focal_amd64.deb
126e4963755cdca440579d81409b3f4a6d6ef4c6c2d4cf435052a13468e2c250  sysbox_0.2.1-0.ubuntu-focal_amd64.deb
```

4) Stop and eliminate all running Docker containers. Refer to the
[detailed](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install.md) installation process for information
on how to avoid impacting existing containers.

```console
$ docker rm $(docker ps -a -q) -f
```

... if an error is returned, it simply indicates that no existing containers were found.

5) Install the Sysbox package and follow the installer instructions:

```console
$ sudo apt-get install ./sysbox_0.2.1-0.ubuntu-focal_amd64.deb -y
```

More information on the installation process can be found [here](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install.md). If you
run into problems during installation, see the [troubleshooting doc](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/troubleshoot.md).

6) Run the PDE with:

```console
docker run -v /workspace:/workspace -v /data:/data --runtime=sysbox-runc --rm -p 8081:8081 -p 80:9001 -p 8888:8888 -p 9000:9000 eoepca/ubuntu-pde:latest start jupyter lab --ip=0.0.0.0 --port=8888 --config=/etc/jupyter/jupyter_notebook_config.py --no-browser --notebook-dir /workspace --allow-root --NotebookApp.token=""
```

**Limited deployment process support**

This deployment will not allow the developer to build or run Docker containers. 

The developer is able to test the applications and processors locally (i.e. not running in Docker containers).

The developer has to use the `cwltool` flag `--no-container` when running CWL workflows.

```console
docker run -v /workspace:/workspace -v /data:/data --rm -p 8081:8081 -p 80:9001 -p 8888:8888 -p 9000:9000 eoepca/ubuntu-pde:latest start jupyter lab --ip=0.0.0.0 --port=8888 --config=/etc/jupyter/jupyter_notebook_config.py --no-browser --notebook-dir /workspace --allow-root --NotebookApp.token=""
```

## Using the PDE

Open the browser at the URL 0.0.0.0 or 127.0.0.1 to access the landing page


