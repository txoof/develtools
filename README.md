# develtools
Development tools for Python in Jupyter Notebook

## nbconvert
nbconvert creates .py files from Jupyter .ipynb files; it adds the appropriate hashbang lines and strips out any cell magic commands.

### Usage:
Command Line:

`$ nbconvert ./myNotebook.py`

From within a Jupyter Notebook:

```
%alias nbconvert nbconvert ./this_notebook_file_name.ipynb
%nbconvert
```

### Requirements
- Jupyter Notebook:
`pip install jupyter`

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
