Component is a central placeholder for all meta-data within the project. In typical IC project, it can be a collection of the certain purposed DV packages, HDL sources etc. Example listed in <link here>.
# fileset
Command to specify all affected files of this component, can use wildcard to collect multiple or certain formatted files, just like:
```
fileset '*/*'
fileset 'path/*.v'
fileset 'path/*.sv*'
```
# generator
Generator is a command to specify the way to generate a target file, for now will have following type of generators:
- not specify or `:default`, then the tool will directly file and put the source file into a file list
- `:link`, to link all files into target out path.
- `:copy`, will copy all files specified by the `fileset` command.
- `:RhDass`, the HDL generator. #TBD
# feature
Component feature declaration, to declare a Component based attribute that can be used within current Component object. `feature ‘width’,1`
# need
A component may need another component, so users don't have to need all components at the design configuration scope, they can just instantiate the components they required, all nested requirements are being solved at component definition. For example:
```
component :name do
  need :uvm
  fileset 'pkg.sv'
end
```
However, the need of a component or a component self cannot add any options, only the config block has that ability.
# variant
It's a low priority feature, may be added in later tool generation. Specify a variant, which will be used to generate a target file or module name. A generator can have a variant option which shall be specified explicitly in component definition, like:
```
component :name do
	variant '_va'
	fileset '*.v'
	generator :link,@variant
end
```
A variant will be automatically added at the end of the certain names, such as HDL module name, file name, and Package name etc.