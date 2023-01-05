pdir=${BEHOME}/boot
workhome=`realpath .`
project=`basename ${workhome}`
## the processed arguments are
## envview=xxx
argumentCommands=`${pdir}/accessory/__optionProcess__.rb ${SHELLTYPE} $@`
eval $argumentCommands
# for test, echo "envview: $envview"

envfile="${workhome}/__be__/${envview}.anchor"
if [ ! -e ${envfile} ]; then
	echo "the specified env file not exists ${envfile}"
	exit 3
fi

## using gnome-terminal by default, others are not supported in current version
## 1.clearing the env by start a new terminal
nterm="/usr/bin/gnome-terminal"
echo $project
termopts="--title \"[booted] ${project}\" --hide-menubar --geometry=120x40+40+40"
setupcmd="source ${BEHOME}/setup.sh ${BEHOME}"
bootcmd="source ${BEHOME}/boot/bin/__bootinNewTerminal__.${SHELLTYPE} ${envfile} ${workhome}"
logincmd="${setupcmd};${bootcmd};${SHELLTYPE}"

echo "booting project env with new terminal"
fullcmd="${nterm} ${termopts} -- ${SHELLTYPE} -c \"${logincmd}\""
# for test, echo "test version:"
echo ${fullcmd}
eval ${fullcmd}

## exit 0