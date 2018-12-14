#!/bin/bash
# Prepare a project to work with pipenv and jupyter
#https://stackoverflow.com/questions/47295871/is-there-a-way-to-use-pipenv-with-jupyter-notebook
add_kernel(){
  #pipenv install ipykernel
  venvDir=`pipenv --venv`
  projectName=`basename $venvDir`
  pipenv run python -m ipykernel install --user --name="${projectName}"
  echo "ipython/jupyter kernelspec is installed for project $projectName"
  echo "you must now launch jupyter notebook and choose the kernel: $projectName"
  read -p "Launch jupyter notebook now? [N/y]" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    jupyter notebook
  fi
}

clean_kernel() {
  venvDir=`pipenv --venv`
  if [ $? -ne 0 ]; then
    echo no virtual environtment found to clean - exiting
    exit 0
  fi
  echo $venvDir
}

pipenv -h > /dev/null 2>&1
if [ $? -eq 0 ]; then
  :
else
  echo pipenv does not appear to be installed in PATH:
  echo $PATH
  exit 1 
fi

case "$1" in
  -a|--add) add_kernel
            ;;
  -c|--clean) clean_kernel
            ;;
  -h|*) scriptName=`basename $0`
      echo help:
      echo    usage: $scriptName [options]
      echo    -a, --add     create a virtual environment and jupyter kernel for this project
      echo    -c, --clean   remove jupyter kernels and virtual environments
      echo    -h            this help
      ;;
esac



