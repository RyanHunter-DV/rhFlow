set pdir = ${BEHOME}/boot
set workhome = `realpath .`
set project = `basename ${workhome}`
## the processed arguments are
## envview=xxx

set argumentCommands = `${pdir}/accessory/__optionProcess__.rb ${SHELLTYPE} $*`
eval $argumentCommands
# for test, echo "envview: $envview"

set envfile = "${workhome}/__be__/${envview}.anchor"
if ( ! -e ${envfile} ) then
	echo "the specified env file not exists ${envfile}"
	exit 3
endif

## using gnome-terminal by default, others are not supported in current version
## 1.clearing the env by start a new terminal
set nterm = "/usr/bin/gnome-terminal"
echo $project
set termopts = "--title \"[booted] ${project}\" --hide-menubar --geometry=120x40+40+40"
set setupcmd = "source ${BEHOME}/setup.sh ${BEHOME}"
set bootcmd  = "source ${BEHOME}/boot/bin/__bootinNewTerminal__.csh ${envfile} ${workhome}"
set logincmd = "${setupcmd};${bootcmd};${SHELLTYPE}"

echo "booting project env with new terminal"
set fullcmd = "${nterm} ${termopts} -- ${SHELLTYPE} -c \"${logincmd}\""
# for test, echo "test version:"
echo ${fullcmd}
eval ${fullcmd}

## exit 0
