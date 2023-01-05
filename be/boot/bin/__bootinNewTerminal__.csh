set envfile  = $1
set workhome = $2

## set common env vars
setenv PROJECT_HOME ${workhome}
set info = `cat ${envfile} | sed -e 's/$/;/'`
## echo $info
set cmdl = "${info}"
#echo $cmdl
eval ${cmdl}
