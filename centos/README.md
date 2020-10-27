## PDE on centos

```bash
docker run --rm -it -p 8889:8889 -p 8890:8888  centos-pde:latest start jupyter lab --ip=0.0.0.0 --port=8888 --config=/etc/jupyter/jupyter_notebook_config.py --no-browser --notebook-dir /workspace --allow-root --NotebookApp.token=""
```