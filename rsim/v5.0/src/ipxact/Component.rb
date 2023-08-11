## doc: [[doc/v1/features/ipxact/Component.md]]
require 'ipxact/Filesets'
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
	
	attr :filelist;
	attr :toolchain;

	# A hash used to store dirs, available pairs:
	# [:published] -> the published dir of this component, out/components/<CompName>
	# [:source] -> the source node dir of this component, for different blocks, the source is different.
	# TODO, which will create unique id for different nodes for this component.
	attr :dirs;

public
	def initialize(name) ##{{{
		super(name);
		@filelist = Filesets.new();
		@toolchain;
	end ##}}}

	## fileset command, to specify source files of this component, files can be specified
	## with wildcard format. Also multiple files can be specified with one fileset command
	## the opts is optional configs for fileset, for example, some of the files are part of
	## the source file, but shall not generated in filelist, then an option can be added like:
	## fileset :filelist=>false, "*.svh"
	def fileset(opts={},*args) ##{{{
		nodepath = currentNodeLocation(:path);
		Rsim.mp.debug("fileset(#{opts},#{args}) called by node(#{nodepath}/node.rh)");
		# by default, the files added by fileset will be added into filelist
		opts[:filelist] = true unless opts.has_key?(:filelist);
		args.each do |fptrn|
			@filelist.addfiles(nodepath,fptrn,opts);
		end
	end ##}}}

	## generator, specify the generator tool to gen the source file to target, supports
	## - :default, use source dir and file directly, skip the generate step.
	## - :copy, copy all found source to target.
	## - :link, symbol link all source to target.
	## - :<custom>, custom tool specified by user.
	## the *args, users can specify specific args for custom tools.
	# if tool is :default, then will return the generator, else set @toolchain
	def generator(tool=:default,*args) ##{{{
		#TODO
		return @toolchain if tool==:default;
		toolname = %Q|#{tool.to_s.capitalize}Generator|;
		require "generators/#{toolname}"
		@toolchain = eval %Q|#{toolname}.new()|;
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


	## API: elaborate, to execute the blocks while stored by user nodes.
	def elaborate ##{{{
		#TODO.
		result = evalUserNodes(:component,self);
		@toolchain = BaseGenerator.new(:default) if @toolchain==nil;
		return result;
	end ##}}}

	## API: addCodeBlock(b), to add code block into this component, and record the block's location.
	def addCodeBlock(b) ##{{{
		#TODO.
		push(b.source_location,b);
	end ##}}}

private
## TODO

end

## define a global command: component, which used by node files to declare a component
## with certain declaration blocks. Multiple component can be declared at different place
##
def component(name,&block) ##{{{
	isNew = false;
	c = Rsim.find(:Component,name);
	if c==nil
		c = Component.new(name);
		isNew=true;
	end
	c.addCodeBlock(block);
	Rsim.register(c) if isNew;
end ##}}}
