Component is a central placeholder for all meta-data within the project. In typical IC project, it can be a collection of the certain purposed DV packages, HDL sources etc. Example listed in <link here>.
This will be placed by a ruby Component class object, while user nodes calls the global 'component' command, which will actually build a ruby ==Component== object, and register it to ==Rsim== module.
# Supported component commands
## fileset
Command to specify all affected files of this component, can use wildcard to collect multiple or certain formatted files, just like:
```
fileset '*/*'
fileset 'path/*.v'
fileset 'path/*.sv*'
```
## generator
Generator is a command to specify the way to generate a target file, for now will have following type of generators:
- not specify or `:default`, then the tool will directly file and put the source file into a file list
- `:link`, to link all files into target out path.
- `:copy`, will copy all files specified by the `fileset` command.
- `:RhDass`, the HDL generator. #TBD
## feature
Component feature declaration, to declare a Component based attribute that can be used within current Component object. `feature ‘width’,1`
## need
A component may need another component, so users don't have to need all components at the design configuration scope, they can just instantiate the components they required, all nested requirements are being solved at component definition. For example:
```
component :name do
  need :uvm
  fileset 'pkg.sv'
end
```
However, the need of a component or a component self cannot add any options, only the config block has that ability.
## variant
It's a low priority feature, may be added in later tool generation. Specify a variant, which will be used to generate a target file or module name. A generator can have a variant option which shall be specified explicitly in component definition, like:
```
component :name do
	variant '_va'
	fileset '*.v'
	generator :link,@variant
end
```
A variant will be automatically added at the end of the certain names, such as HDL module name, file name, and Package name etc.
## params
The parameters can be defined by a component, which can be used in component declaration blocks, to certainly determine different behaviors, like:
```ruby
component :name do
	params :pa=>10
	if @pa==10
		need :ComponentA
	else
		need ComponentB
	end
	...
end
```
# Container component
A container component is a component that only used as a container by variety sub components required by the `need` command. In this typed component, the generator, fileset commands are useless, but will not ignored. And users can define a container component which can be used by higher level integration.


