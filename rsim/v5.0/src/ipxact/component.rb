## doc: [[doc/v1/features/ipxact/Component.md]]
class Component < MetaData
	"""
	class for generating an IP-XACT component, which will be a collection
	of the meta-data.
	# Features
	- support commands:
		- generator, specify which tool to call to generate the specified files
		- fileset, collect files as the source file, this will be used by generator
		-
	"""
	
public
	def initialize(name) ##{{{
		super(name);
	end ##}}}

	## fileset command, to specify source files of this component, files can be specified
	## with wildcard format. Also multiple files can be specified with one fileset command
	## the opts is optional configs for fileset, for example, some of the files are part of
	## the source file, but shall not generated in filelist, then an option can be added like:
	## fileset :filelist=>false, "*.svh"
	def fileset(opts={},*args) ##{{{
		#TODO
	end ##}}}

	## generator, specify the generator tool to gen the source file to target, supports
	## - :default, use source dir and file directly, skip the generate step.
	## - :copy, copy all found source to target.
	## - :link, symbol link all source to target.
	## - :<custom>, custom tool specified by user.
	## the *args, users can specify specific args for custom tools.
	def generator(tool=:default,*args) ##{{{
		#TODO
	end ##}}}

	## params, to declare parameters for this component, params can be overridden by a design configuration
	## params shall be declared with a format as a hash, like:
	## params :pa=>'10',:pb=>11 ...
	## those params will be finally defined as an instance variable in this component, and it can be used
	## to determine the behavior of component blocks.
	def params(plist) ##{{{
		#TODO.
	end ##}}}

	## API: need, this used by a component to indicate that if users want to embed this component, it's dependent
	## requirement will be embeded as well. In a design, different component may need same requirements, so in design
	## level, will do unique operation to skip duplicate quoting of the same component.
	def need(comp) ##{{{
		#TODO
	end ##}}}

private
## TODO

end

## define a global command: component, which used by node files to declare a component
## with certain declaration blocks. Multiple component can be declared at different place
##
def component(name,&block) ##{{{
	#TODO
end ##}}}
