build:= 'xcelium.build(:testConfig)'
debug:= -d
# debug:=
compile:= 'xcelium.compile(:test)'
simulation:= 'xcelium.run(:test)'
simonly := 'xcelium.sim(:test)'

all:
	../simf ${debug} -e ${build}
comp:
	../simf ${debug} -e ${compile}
sim:
	../simf ${debug} -e ${simonly}
run:
	../simf ${debug} -e ${simulation}
clean:
	rm -rf out
