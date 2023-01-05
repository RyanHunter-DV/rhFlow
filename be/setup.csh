set cdir = $1
setenv SHELLTYPE tcsh


## loading app
setenv BEHOME "${cdir}"
setenv APPHOME "${BEHOME}/app/bin"

#TODO, not work tmp, alias app "source ${APPHOME}/appShell.csh"
alias ubootenv "source ${BEHOME}/boot/bin/bootShell.csh"
