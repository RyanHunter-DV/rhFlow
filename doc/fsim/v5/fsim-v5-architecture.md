# Overivew
## Feature list
### support functional simulation flow
define the simulation flow into:
- [[#publish phase]], to publish source files into a temp dir.
	- integrate IP-XACT compliant tools to publish the RTL.
	- integrate other projects which has the same structure of this project.
	- publish with different configurations, different configuration can publish different RTL code.
- build phase, to build the database for simulation, such as compile/elaborate by EDA tools.
	- support EDA parition compile.
- test phase, run tests specified by user.


### support regression flow
### facilitate verification debugging
### easy to install this tool

# Concept and terminology
## component
A component is a central place holder for object meta-data, a component can be a set of RTL/verif files with specific options.
And a component can be included in any other components.
*user source example of component*:
```ruby
component :name do
	# supported options for this component
	option :sim => 'xxx'
	option :comp => 'xxx'
	to = 'xxxx'
	option :sim => to
	# include other components
	required Ip1.compname do
		option :sim => to
		option :comp => 'bbb'
	end
	
end
```
more examples for component : [[component examples]]

## design
A design is a collection of components, for a specific fsim scope, so each design is top perspective for current fsim running.
*user source example*:
```ruby
design :designname do
	component :compname, :as => :instname
	component :test
	component Ip0.compname, :as => :instname
end
```

## config
A design can be published with different configurations, so a 'config' concept is used to publish files, build database, and run by a specific test.
design is simply a collection of different components, connections. Configurations of this design will be established here.
A config will contain a design, and specify different options, like:
```ruby
config :configname do
	required :designname, :as => :dn
	dn.option
end
```

## test
A test is used while in run phase, calling a test, the config should be specified for building, like:
```ruby
test :testname do
	
end
```

# Feature Description
## publish phase
The publish phase will publish source files into target location. With specified operations:
- copy, this is built-in operation, copies files directly to target according to a flow generated Makefile.
- alias, create symbol alias directly.
- third party tools, according to user source, start a third party tool to do publishing.
### support different publish configuration
To support this feature, we need a concept called 'config', by declaring config each time a specific options can be added and every time the tool publishes files, it will
choose one config to publish. The config supports:
- different macros
- include different component, or same component with different config.
## establish a component
a component is a place holder, which is used to publishing files, with different options
### options for a component
- builtin options are sim option and build option (for xcelium, may contain compile and elaborate option)
- direct pass options will pass the options directly to EDA tools.
- 

#TODO
### files and publish methods
#TODO 

## allocating tests
This feature allows users to specify test configurations simply through the `test` command in test.rh files, and a test publish tool
will automatically publish tests, instead of writing the detailed tests in SV.
examples and minds here: [[test publish examples]]
#TBD , wait for test builder project.

# Architecture




---
