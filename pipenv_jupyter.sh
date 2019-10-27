#!/bin/bash
# created by Aaron Ciuffo https://github.com/txoof
# version 0 15 December 2018

# Prepare a project to work with pipenv and jupyter by creating a pipvenv and adding
# the kernelspec to jupyter's list of available kernels 
# additional modules can be added by running pipenv install <module>

# Thanks to Luis Meraz: https://stackoverflow.com/users/8017204/luis-meraz
#https://stackoverflow.com/questions/47295871/is-there-a-way-to-use-pipenv-with-jupyter-notebook
add_kernel(){
  pyVersion=$1
  python=`which $2`
  if [[ -x $python ]]
  then
    echo "using $python to install setup base environment and install kernelspec"
  else
    echo "could not find an executable for $2; exiting"
    exit 0
  fi

  echo "PYTHON VERSION: $pyVersion"
  #pipenv "${pyVersion}" install ipykernel
  pipenv "${pyVersion}"
  venvDir=`pipenv --venv`
  projectName=`basename $venvDir`
  #pipenv run python -m ipykernel install --user --name="${projectName}"
  $python -m ipykernel install --user --name="${projectName}"
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
  -2) add_kernel "--two" "python2"
            ;;
  -3) add_kernel "--three" "python3"
            ;;
  -c|--clean) clean_kernel
            ;;
  -h|*) 
      scriptName=`basename $0`
      echo creates a virtual environment and adds a ipython/jupyter kernelspec
      echo help:
      echo     usage: $scriptName "[-2|-3|-c|-h]"
      echo '   -2, --two     create a Python 2 virtual environment and jupyter kernel for this project'
      echo '   -3, --three   create a Python 3 virtual environment and jupyter kernel for this project'
      echo '   -c, --clean   remove jupyter kernels and virtual environments'
      echo '   -h            this help'
      ;;
esac
