
c = get_config()

c.FileContentsManager.delete_to_trash=False

c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False

#c.JupyterLabTemplates.template_dirs = ['/workspace/templates', '/home/jovyan/templates']
#c.JupyterLabTemplates.include_default = False
#c.JupyterLabTemplates.include_core_paths = False



#import os
c.ServerProxy.servers = {
  'theia': {
    'command': [
      '/home/jovyan/.nvm/versions/node/v12.19.0/bin/yarn',
        'start', 
        '/workspace',
        '--hostname=0.0.0.0',
        '--port={port}'
    ],
    'timeout': 30,
    'launcher_entry': {
      'title': 'Theia'
    }
  }
}