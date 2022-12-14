#! /usr/bin/env bash
# echo "app-v1 called, params: $@"

## get the root dir of app*
## cdir=`dirname $0 | xargs realpath `
cdir=$APPHOME
pdir=`dirname $cdir`

## process options by calling ../accessory/__optionProcess__.py
## the option processor will need the SHELLTYPE env from setup.*sh
argumentCommands=`${pdir}/accessory/__optionProcess__.rb $@`

## the eval will define:
## cmd=xxx
## tool=xxx
## version=xxx, if cmd is unload, version is ignored
eval $argumentCommands
echo "${cmd} tool: ${tool}, version: ${version}"

appConfig="/tools/${tool}/${version}/app.config"
if [ ! -e $appConfig ]; then
	echo "Error, no app.config file found for: ${appConfig}"
	return 3
fi
## app.config exists, now loading the config file
setupCommands=`${pdir}/accessory/__appConfigProcess__.rb ${appConfig} ${cmd}`
## echo "load: $setupCommands"
if [ ! -z "${setupCommands}" ]; then
	eval $setupCommands
fi

echo "Success, ${cmd} completed"
return 0
