# develtools
Development tools for Python in Jupyter Notebook

## nbconvert.py
nbconvert.py converts notebook files using custom templates and provides hints for adding templates

**IMPORTANT**
Templates are avilable in the `nbconvert_templates` directory

### Usage:
Command Line:

```
usage: nbconvert.py [-h] [-t TEMPLATE] [-o OUTPUT_DIR] [--to TO] input_file

convert jupyter notebooks using custom tempaltes

positional arguments:
  input_file            notebook file to convert -- required

optional arguments:
  -h, --help            show this help message and exit
  -t TEMPLATE, --template TEMPLATE
                        choose from a custom template stored in
                        /Users/aaronciuffo/Library/Jupyter/nbconvert/templates
  -o OUTPUT_DIR, --output_dir OUTPUT_DIR
  --to TO               convert notebook to format [python*, html, latex, pdf, webpdf, slides,
                        mardown, ascidoc, rst, script, notebook] *default

    EXAMPLES:
    Basic conversion of notebook to python using a custom template
        $ nbconvert.py --template python_clean foo.ipynb

    Convert notebook to markdown
        $ nbconvert.py --to markdown bar.ipynb

    Convert notebook to python using a custom template and alternate output directory
        $ nbconvert.py --template python_clean --output_dir ./spam/ham monty.ipynb
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
