#! /usr/bin/env bash
## processing steps
## 1.setup the alias for be, and path for app
##cdir=`dirname $0 | xargs realpath `
cdir=$1
export SHELLTYPE=bash

## loading app
export BEHOME="${cdir}"
export APPHOME="${BEHOME}/app/bin"

## this file cannot be loaded by zsh since it has no shopt command
## and I can't solve it for now.
shopt -s expand_aliases
alias app="source ${APPHOME}/appShell.bash"
#export PATH=${APPHOME}:$PATH
alias bootenv="source ${BEHOME}/boot/bin/bootShell.bash"

# TODO
