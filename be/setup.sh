#! /usr/bin/env bash
## processing steps
## 1.setup the alias for be, and path for app
##cdir=`dirname $0 | xargs realpath `
cdir=$1
export SHELLTYPE=bash

## loading app
export APPHOME="${cdir}/app/bin"
alias app="source $cdir/app/bin/appShell.bash"

# TODO
