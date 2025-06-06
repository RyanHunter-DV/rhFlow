#! /usr/bin/env zsh
## processing steps
## 1.setup the alias for be, and path for app
##cdir=`dirname $0 | xargs realpath `
cdir=$1
export SHELLTYPE=zsh

## loading app
export BEHOME="${cdir}"
export APPHOME="${BEHOME}/app/bin"

alias app="source ${APPHOME}/appShell.bash"
#export PATH=${APPHOME}:$PATH
alias bootenv="source ${BEHOME}/boot/bin/bootShell.bash"
