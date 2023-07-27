This chapter will describe all concepts and possible commands used for root and node files, which are used to assemble and run a project.
# Component
Component is a central placeholder for all meta-data within the project. In typical IC project, it can be a collection of the certain purposed DV packages, HDL sources etc.
Example listed in [component/node.rh](https://github.com/RyanHunter-DV/rhFlow/rsim/v5.0/examples/)
## fileset
Command to specify all affected files of this component, can use wildcard to collect multiple or certain formatted files, just like:
```ruby
fileset '*/*'
fileset 'path/*.v'
fileset 'path/*.sv*'
```
## generator
Generator is a command to specify the way to generate a target file, for now will have following type of generators:
- not specify, then the tool will directly file and put the source file into a file list
- `:link`, to link all files into target out path.
- `:copy`, will copy all files specified by the `fileset` command.
- `:RhDass`, the HDL generator. #TBD 

## feature
#TBD 
Component feature declaration, to declare a Component based attribute that can be used within current Component object.
`feature ‘width’,1`

## need
A component may need another component, so users don't have to need all components at the design configuration scope, they can just instantiate the components they required, all nested requirements are being solved at component definition. For example, if a config need a design with view a, then it can only define the config like:
```ruby
config :Cname do
	DesignA(:viewname)
	compOpt :vcs, 'xxxx'
	simOpt :vcs, 'xxxx'
end
```

## variant
It's a low priority feature, may be added in later tool generation.
Specify a variant, which will be used to generate a target file or module name. A generator can have a variant option which shall be specified explicitly in component definition, like:
```ruby
component :name do
	variant '_va'
	fileset '*.v'
	generator :link,@variant
end
```
A variant will be automatically added at the end of the certain names, such as HDL module name, file name, and Package name etc.

# Design
Design, which is also means a design context, is collection of all components which will be included while loading it. The design can have component instances with specific views.
#PH

## view
A certain view of a design can be used to setup certain component instances, generator and tool options, by which a config can be easier by just using a certain view of a design.
# Design configuration
A certain config is to generate a certain purposed design context. It can declare the views, parameters, and tool options that to run.
