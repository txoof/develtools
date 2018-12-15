#!/bin/bash
# created by Aaron Ciuffo https://github.com/txoof
# version 0 15 December 2018
# Prepare a project to work with pipenv and jupyter
# Thanks to Luis Meraz: https://stackoverflow.com/users/8017204/luis-meraz
#https://stackoverflow.com/questions/47295871/is-there-a-way-to-use-pipenv-with-jupyter-notebook
add_kernel(){
  pipenv install ipykernel
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
    # throw error from pipenv and exit 
    exit 0
  else
    venvName=`basename $venvDir`
  fi

  echo removing kernelspec and virutal environment: $venvName
  jupyter kernelspec remove `echo $venvName | tr '[:upper:]' '[:lower:]'`
  if [ $? -ne 0 ]; then
    echo failed to clean up jupyter kernel
    echo try to manually remove using:
    echo jupyter kernelspec remove $venvName
  fi

  pipenv --rm 
  if [ $? -ne 0 ]; then
    echo failed to remove pip virtual environment - exiting
    echo try to manually remove using:
    echo pipenv -rm
  fi
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
