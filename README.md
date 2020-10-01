# develtools
Development tools for Python in Jupyter Notebook

## nbconvert
This script simply survives as a reminder to update notebook magic cells.
This was formerly a shortcut for converting notebooks now replaced with notebook magic:
`!jupyter-nbconvert --to python --template python_clean`

Update notebook magic cells with the above magic.

### Requirements
- Jupyter Notebook:
`pip install jupyter`

## nbconvert_templates
Custom templates for nbconvert. Try `nbconvert.py -h` to find the custom template directory (this can be a symlink?)

## pipenv_jupyter
pipenv_jupyter.sh creates a pipenv virtual environment that will play nice with Jupyter in the current working directory.

### Usage:
- Create a new Jupyter Kernel for Python 3 around the pipenv in this directory:
`$ pipenv_jupyter.sh -3`

- Clean up an installed kernel and remove symlinks:
`$ pipenv_jupyter.sh -c`

### Requirements:
- Jupyter Notebook:
`pip install jupyter`
- pipenv
`pip install pipenv`
