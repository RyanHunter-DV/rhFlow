pdir=${BEHOME}/boot
workhome=`realpath .`
project=`basename ${workhome}`
## the processed arguments are
## envview=xxx
argumentCommands=`${pdir}/accessory/__optionProcess__.rb ${SHELLTYPE} $@`
## echo $argumentCommands
eval $argumentCommands
## echo "test envview: $envview"
## echo "test newterm: $newterm"

envfile="${workhome}/__be__/${envview}.anchor"
if [ ! -e ${envfile} ]; then
	echo "the specified env file not exists ${envfile}"
	exit 3
fi

## using gnome-terminal by default, others are not supported in current version
## 1.clearing the env by start a new terminal
nterm="/usr/bin/gnome-terminal"
echo "project: ${project}"
termopts="--title \"[booted] ${project}\" --hide-menubar --geometry=120x40+40+40"
setupcmd="source ${BEHOME}/setup.sh ${BEHOME}"
bootcmd="source ${BEHOME}/boot/bin/__bootinNewTerminal__.${SHELLTYPE} ${envfile} ${workhome}"
logincmd="${setupcmd};${bootcmd};${SHELLTYPE}"
localcmd="${setupcmd};${bootcmd};"

if [ ${newterm} == 1 ]; then
	echo "booting project env with new terminal"
	fullcmd="${nterm} ${termopts} -- ${SHELLTYPE} -c \"${logincmd}\""
else
	echo "booting project env with local terminal"
	fullcmd="${localcmd}"
fi
# for test, echo "test version:"
echo ${fullcmd}
eval ${fullcmd}

## exit 0
