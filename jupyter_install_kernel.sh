#!/bin/env bash


function do_exit {
  echo $1
  exit 1
}

venvDir=$(pipenv --venv) && echo "venv checks out; adding kernel" || do_exit "no pipenv exists, create first then rerun this command"

#venvDir=$(pipenv --venv)
projectName=$(basename ${venvDir})
echo pn: $projectName
pipenv install ipykernel --skip-lock
pipenv run python -m ipykernel install --user --name="$projectName"
