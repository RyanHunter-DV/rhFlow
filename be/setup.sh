#! /usr/bin/env bash
## processing steps
## 1.setup the alias for be, and path for app
cdir=`dirname $0 | xargs realpath `
export SHELLTYPE=bash

## loading app
alias app="source $cdir/app/bin/appShell.bash"

# TODO
