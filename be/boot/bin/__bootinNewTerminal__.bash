#! /usr/bin/env bash
envfile=$1
workhome=$2

## set common env vars
export PROJECT_HOME=${workhome}
info=`cat ${envfile} | sed -e 's/$/;/'`
## echo $info
cmdl="${info}"
eval ${cmdl}
